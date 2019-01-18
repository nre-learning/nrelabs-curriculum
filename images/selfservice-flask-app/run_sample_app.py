import os
import sys
from flask import Flask

sys.path.append(os.path.dirname(__name__))
from sample_application import create_app
app = create_app()

if __name__ == '__main__':
    # Relevant documents:
    # http://werkzeug.pocoo.org/docs/middlewares/
    # http://flask.pocoo.org/docs/patterns/appdispatch/
    from werkzeug.serving import run_simple
    from werkzeug.wsgi import DispatcherMiddleware
    app.config['DEBUG'] = True
    # Load a dummy app at the root URL to give 404 errors.
    # Serve app at APPLICATION_ROOT for localhost development.
    application = DispatcherMiddleware(app, {
        app.config['APPLICATION_ROOT']: app,
    })
    run_simple('0.0.0.0', 5000, application, use_reloader=True)


