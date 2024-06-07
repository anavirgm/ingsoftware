from flask import Flask, render_template, request, redirect, url_for, flash, session
from flask_mysqldb import MySQL
from flask_bcrypt import Bcrypt
import MySQLdb.cursors

app = Flask(__name__)
app.secret_key = "your_secret_key"

app.config["MYSQL_HOST"] = "localhost"
app.config["MYSQL_USER"] = "root"
app.config["MYSQL_PASSWORD"] = ""
app.config["MYSQL_DB"] = "camicandy"

mysql = MySQL(app)
bcrypt = Bcrypt(app)


@app.route("/", methods=["GET", "POST"])
def login():
    if (
        request.method == "POST"
        and "username" in request.form
        and "password" in request.form
    ):
        username = request.form["username"]
        password = request.form["password"]

        cursor = mysql.connection.cursor(MySQLdb.cursors.DictCursor)
        cursor.execute("SELECT * FROM usuarios WHERE cedula = %s", (username,))
        user = cursor.fetchone()

        if user and bcrypt.check_password_hash(user["hash_de_contrasena"], password):
            session["loggedin"] = True
            session["id"] = user["id"]
            session["username"] = user["nombre"]
            session["rol"] = user["rol"]
            return redirect(url_for("dashboard"))
        else:
            flash("Usuario o contraseña incorrectos")

    return render_template("index.html")


@app.route("/dashboard")
def dashboard():
    if "loggedin" in session:
        return render_template(
            "dashboard.html", username=session["username"], rol=session["rol"]
        )
    return redirect(url_for("login"))


@app.route("/productos")
def productos():
    if "loggedin" in session:
        return render_template(
            "productos.html", username=session["username"], rol=session["rol"]
        )
    return redirect(url_for("login"))


@app.route("/clientes", methods=["GET", "POST"])
def clientes():
    if "loggedin" not in session:
        return redirect(url_for("login"))

    if request.method == "POST":
        # formulario para agregar un nuevo cliente
        nombre = request.form["nombre"]
        direccion = request.form["direccion"]
        telefono = request.form["telefono"]
        cedula = request.form["cedula"]

        cursor = mysql.connection.cursor(MySQLdb.cursors.DictCursor)
        cursor.execute(
            "INSERT INTO clientes (nombre, direccion, telefono, cedula) VALUES (%s, %s, %s, %s)",
            (nombre, direccion, telefono, cedula),
        )
        mysql.connection.commit()
        cursor.close()
        flash("Cliente agregado correctamente")

    cursor = mysql.connection.cursor(MySQLdb.cursors.DictCursor)
    cursor.execute("SELECT * FROM clientes")
    clientes = cursor.fetchall()
    cursor.close()

    return render_template("clientes.html", clientes=clientes)


@app.route("/clientes/<id>", methods=["GET", "PUT"])
def cliente(id):
    # redireccionar si no hay una sesión activa
    if "loggedin" not in session:
        return redirect(url_for("login"))

    # vista de cliente detallada donde se podrá editar la información del usuario
    if request.method == "GET":
        cursor = mysql.connection.cursor(MySQLdb.cursors.DictCursor)
        # hacer la consulta
        cursor.execute(
            "SELECT * FROM clientes WHERE id = %s",
            (id),
        )
        # extraer la información del cliente
        cliente = cursor.fetchone()
        if cliente:
            mysql.connection.commit()
            cursor.close()
            return render_template("cliente.html", cliente=cliente)

        # en el caso de que no exista un usuario con ese id, mantenerse en la lista de clientes
        return redirect(url_for("clientes"))


@app.route("/proveedores", methods=["GET", "POST"])
def proveedores():
    if "loggedin" not in session:
        return redirect(url_for("login"))

    if request.method == "POST":
        nombre = request.form["nombre"]
        direccion = request.form["direccion"]
        rif = request.form["rif"]

        cursor = mysql.connection.cursor(MySQLdb.cursors.DictCursor)
        cursor.execute("INSERT INTO proveedores (nombre, direccion, rif) VALUES (%s, %s, %s)",
                       (nombre, direccion, rif))
        mysql.connection.commit()
        cursor.close()
        flash("Proveedor agregado correctamente")

    cursor = mysql.connection.cursor(MySQLdb.cursors.DictCursor)
    cursor.execute("SELECT * FROM proveedores")
    proveedores = cursor.fetchall()
    cursor.close()

    return render_template("proveedores.html", proveedores=proveedores)


@app.route("/recuperar_contrasena", methods=["GET", "POST"])
def recuperar_contrasena():
    if request.method == "POST" and "username" in request.form:
        username = request.form["username"]

        cursor = mysql.connection.cursor(MySQLdb.cursors.DictCursor)
        cursor.execute(
            "SELECT pregunta_seguridad FROM usuarios WHERE cedula = %s", (username,)
        )
        user = cursor.fetchone()

        if user:
            session["recuperar_username"] = username
            session["pregunta_seguridad"] = user["pregunta_seguridad"]
            return redirect(url_for("verificar_respuesta"))
        else:
            flash("Usuario no encontrado")

    return render_template("recuperar_contrasena.html")


@app.route("/verificar_respuesta", methods=["GET", "POST"])
def verificar_respuesta():
    if "recuperar_username" not in session:
        return redirect(url_for("recuperar_contrasena"))

    if request.method == "POST" and "respuesta" in request.form:
        respuesta = request.form["respuesta"]
        username = session["recuperar_username"]

        cursor = mysql.connection.cursor(MySQLdb.cursors.DictCursor)
        cursor.execute("SELECT * FROM usuarios WHERE cedula = %s", (username,))
        user = cursor.fetchone()

        if user and bcrypt.check_password_hash(user["respuesta_seguridad"], respuesta):
            return redirect(url_for("cambiar_contrasena"))
        else:
            flash("Respuesta incorrecta")

    return render_template(
        "verificar_respuesta.html", pregunta_secreta=session["pregunta_seguridad"]
    )


@app.route("/cambiar_contrasena", methods=["GET", "POST"])
def cambiar_contrasena():
    if "recuperar_username" not in session:
        return redirect(url_for("recuperar_contrasena"))

    if request.method == "POST" and "nueva_contrasena" in request.form:
        nueva_contrasena = request.form["nueva_contrasena"]
        username = session["recuperar_username"]

        hash_de_nueva_contrasena = bcrypt.generate_password_hash(
            nueva_contrasena
        ).decode("utf-8")

        cursor = mysql.connection.cursor(MySQLdb.cursors.DictCursor)
        cursor.execute(
            "UPDATE usuarios SET hash_de_contrasena = %s WHERE cedula = %s",
            (hash_de_nueva_contrasena, username),
        )
        mysql.connection.commit()
        cursor.close()

        session.pop("recuperar_username", None)
        session.pop("pregunta_secreta", None)
        flash("Contraseña cambiada correctamente")
        return redirect(url_for("login"))

    return render_template("cambiar_contrasena.html")


@app.route("/logout")
def logout():
    session.pop("loggedin", None)
    session.pop("id", None)
    session.pop("username", None)
    session.pop("rol", None)
    return redirect(url_for("login"))


if __name__ == "__main__":
    app.run(debug=True)
