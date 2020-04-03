def update_hostname (ssh_client, hostname):

    ssh.exec_command("sudo sed -E -i 's/^(127\.0\.1\.1\s+).*/\1" + hostname + "/ /etc/hosts")
    ssh.exec_command("sudo printf '%s' '" + hostname + "' > /etc/hostname")
    ssh.exec_command("sudo hostname " + hostname)

return




