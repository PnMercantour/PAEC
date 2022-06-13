wsgi_app = 'app:server'

# change binding when using a reverse proxy
bind= "0.0.0.0:9001"
# logging
accesslog = 'log/access.log'
errorlog = 'log/error.log'

#daemon = True
user = None
group = None

workers = 2
backlog = 64

# TODO bind to a unix socket