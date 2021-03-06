from flask import Flask
from flask import render_template

app = Flask(__name__, static_url_path='/static')


# a simple page that says hello
@app.route('/')
def hello():
    return render_template('index.html')


if __name__ == "__main__":
    app.run(debug=True)
