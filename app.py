from flask import Flask
from my_project.regions.route.region_route import regions_bp
from my_project.machines.route.machine_route import machines_bp
from my_project.menu.route.menu_route import menu_bp

app = Flask(__name__)

app.register_blueprint(regions_bp)
app.register_blueprint(machines_bp)
app.register_blueprint(menu_bp)

if __name__ == "__main__":
    app.run(debug=True)
