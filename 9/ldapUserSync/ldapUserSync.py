#!/usr/bin/env python
# encoding: utf-8
"""
ldapUserSync.py
This little script will sync ldap admin user with openvas user. A work around to openvas per-user ldap limitation
Created by lhan on 2015-07-17.
"""
import os
import sys
import getopt
import shlex
import subprocess
from sets import Set 
from config import config
from os import environ


def get_config(key):
    try:
        envKey = key.upper()
        value = environ[envKey]
    except:
        value = config.get(key)
    return value

help_message = '''
Sync admin user from ldap to openvas
'''
# LDAP Configuration
host = get_config('ldap_host')
bindDN = get_config('ldap_bind_dn')
baseDN = get_config('ldap_base_dn')
ldapFilter = get_config('ldap_admin_filter')
ldapPwd = get_config('ldap_password') 

# OpenVAS configuration
ovUser = 'admin'
ovPwd = get_config('ov_password')

ADMIN_ROLE_ID = '7a8cb5b4-b74d-11e2-8187-406186ea4fc5'
UID_ATT = get_config('ldap_username_attr')


ldapUsers = Set([])
ovUsers = Set([])

# Utils
BASH = lambda x: (subprocess.Popen(shlex.split(x), stdout=subprocess.PIPE, stderr=subprocess.STDOUT, shell=False).communicate()[0])


class Usage(Exception):
    def __init__(self, msg):
        self.msg = msg


def main(argv=None):
    if argv is None:
        argv = sys.argv
    try:
        try:
            opts, args = getopt.getopt(argv[1:], "hv:H:D:b:w:f:u:W:", ["help",  "host=", "bind=", "base=", "ldap-pass=", "ldap-filter=", "username=", "password="])
        except getopt.error, msg:
            raise Usage(msg)
    
        # option processing
        for option, value in opts:
            if option == "-v":
                verbose = True
            if option in ("-h", "--help"):
                raise Usage(help_message)
            # ldap host
            if option in ("-H", "--host"):
                global host
                host = value
            # ldap bindDN(-D)
            if option in ("-D", "--bind"):
                global bindDN
                bindDN = value
            # ldap baseDN(-b)
            if option in ("-b", "--base"):
                global baseDN
                baseDN = value
            # ldap password(-w)
            if option in ("-w", "--ldap-pass"):
                global ldapPwd
                ldapPwd = value
            # filter(-f)
            if option in ("-f", "--ldap-filter"):
                global ldapFilter
                ldapFilter = value
            # openvas username (-u)
            if option in ("-u", "--username"):
                global ovUser
                ovUser = value
            # openvas password(-W)
            if option in ("-W", "--password"):
                global ovPwd
                ovPwd = value
    except Usage, err:
        print >> sys.stderr, sys.argv[0].split("/")[-1] + ": " + str(err.msg)
        print >> sys.stderr, "\t for help use --help"
        return 2
    syncUsers()

def getLdapUser():
    global ldapUsers
    if len(ldapUsers) == 0:
        ldapUsersCmd = "ldapsearch -H ldaps://%s -D %s -b %s -w %s \'(%s)\' %s"%(host, bindDN, baseDN, ldapPwd, ldapFilter, UID_ATT)
        ldapUsersCmdResponse = BASH(ldapUsersCmd)
        uidAttrP = '%s: '%(UID_ATT)
        for line in ldapUsersCmdResponse.split('\n'):
            if line.find(uidAttrP) != -1 :
                ldapUsers.add(line.split(uidAttrP)[1])
    return ldapUsers
    
def getOpenVasUsers():
    global ovUsers
    if len(ovUsers) == 0:
        ovUsersCmd =  "openvasmd --get-users"
        ovUsersCmdResponse = BASH(ovUsersCmd)
        for line in ovUsersCmdResponse.split('\n'):
            if len(line) > 0:
                ovUsers.add(line)
        
    return ovUsers

def createUser(userName):
    cmd = '''omp -u %s -w %s -X "<create_user><name>%s</name><role id='%s'/><sources><source>ldap_connect</source></sources></create_user>"'''%(ovUser, ovPwd, userName, ADMIN_ROLE_ID)
    resp = BASH(cmd)
    if resp.find("OK, resource created") != -1:
        print "Sucess to create user %s"%(userName)
        return True
    else:
        print "Fail to create user %s: %s"%(userName, resp)
        return False

def syncUsers():
    ldapUsers = getLdapUser()
    ovUsers = getOpenVasUsers()
    usersToCreate = ldapUsers - ovUsers
    map(createUser, usersToCreate)
    
if __name__ == "__main__":
    sys.exit(main())
