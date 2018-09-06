# Disabling all security for now (NEED TO REMEMBER TO RE ENABLE THIS)
c.NotebookApp.token = ''
c.NotebookApp.password = ''

# hash is "juniper"
# c.NotebookApp.password = 'sha1:9fd6b8a45182:3cdeb2d4e19729e0bbb6504c5c3ebc98de5d23b1'
# c.NotebookApp.password_required = False

c.NotebookApp.notebook_dir = '/antidote/lessons'

# For embedding inside other pages
c.NotebookApp.tornado_settings = { 'headers': { 'Content-Security-Policy': "frame-ancestors 'self' https://labs.networkreliability.engineering/" } }