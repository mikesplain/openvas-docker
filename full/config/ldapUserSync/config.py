config = {
    # LDAP configuration
    'ldap_host' : 'YOUR HOST',
    'ldap_bind' : 'uid=bindUid,cn=sysaccounts,dc=company,dc=com',
    'ldap_base' : 'cn=accounts,dc=company,dc=com',
    'ldap_admin_filter' : 'memberOf=cn=admins,cn=groups,cn=accounts,dc=company,dc=com',
    'ldap_password' : 'password',
    'ldap_username_attr' : 'uid',

    # OpenVAS configuration
    'ov_password' : 'admin'
}
