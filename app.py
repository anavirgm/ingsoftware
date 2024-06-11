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
        cursor = mysql.connection.cursor(MySQLdb.cursors.DictCursor)

        # Obtener la cantidad de productos
        cursor.execute("SELECT COUNT(*) AS total_productos FROM productos")
        total_productos = cursor.fetchone()["total_productos"]

        # Obtener la cantidad de clientes
        cursor.execute("SELECT COUNT(*) AS total_clientes FROM clientes")
        total_clientes = cursor.fetchone()["total_clientes"]

        # Obtener la cantidad de proveedores
        cursor.execute("SELECT COUNT(*) AS total_proveedores FROM proveedores")
        total_proveedores = cursor.fetchone()["total_proveedores"]

        cursor.execute("SELECT COUNT(*) AS total_transacciones FROM transacciones")
        total_transacciones = cursor.fetchone()["total_transacciones"]

        cursor.close()

        return render_template(
            "dashboard.html",
            username=session["username"],
            rol=session["rol"],
            total_productos=total_productos,
            total_clientes=total_clientes,
            total_proveedores=total_proveedores,
            total_transacciones=total_transacciones,
        )
    return redirect(url_for("login"))


@app.route("/productos")
def productos():
    if "loggedin" in session:
        return render_template(
            "productos.html", username=session["username"], rol=session["rol"]
        )
    return redirect(url_for("login"))


#################################### CLIENTES ################################################


@app.route("/clientes", methods=["GET", "POST"])
def clientes():
    if "loggedin" not in session:
        return redirect(url_for("login"))

    if request.method == "POST":
        # Formulario para agregar un nuevo cliente
        nombre = request.form["nombre"]
        direccion = request.form["direccion"]
        telefono = request.form["telefono"]
        cedula = request.form["cedula"]

        cursor = mysql.connection.cursor(MySQLdb.cursors.DictCursor)
        cursor.execute(
            "INSERT INTO clientes (nombre, direccion, telefono, cedula, status) VALUES (%s, %s, %s, %s, 1)",
            (nombre, direccion, telefono, cedula),
        )
        mysql.connection.commit()
        cursor.close()
        flash("Cliente agregado correctamente")

    cursor = mysql.connection.cursor(MySQLdb.cursors.DictCursor)
    cursor.execute(
        "SELECT * FROM clientes WHERE status = 1"
    )  # Solo mostrar clientes activos
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


@app.route("/eliminar_clientes", methods=["POST"])
def eliminar_clientes():
    if "loggedin" not in session:
        return redirect(url_for("login"))

    cliente_ids = request.form.getlist("cliente_ids")
    cursor = mysql.connection.cursor()
    for cliente_id in cliente_ids:
        cursor.execute(
            "UPDATE clientes SET status = %s WHERE id = %s", (False, cliente_id)
        )
    mysql.connection.commit()
    cursor.close()
    flash("Clientes eliminados correctamente")

    return redirect(url_for("clientes"))


@app.route("/obtener_cliente/<int:id>", methods=["GET"])
def obtener_cliente(id):
    if "loggedin" not in session:
        return redirect(url_for("login"))

    cursor = mysql.connection.cursor(MySQLdb.cursors.DictCursor)
    cursor.execute("SELECT * FROM clientes WHERE id = %s", (id,))
    cliente = cursor.fetchone()
    cursor.close()

    return cliente


@app.route("/actualizar_cliente", methods=["POST"])
def actualizar_cliente():
    if "loggedin" not in session:
        return redirect(url_for("login"))

    id = request.form["id"]
    nombre = request.form["nombre"]
    direccion = request.form["direccion"]
    telefono = request.form["telefono"]
    cedula = request.form["cedula"]

    cursor = mysql.connection.cursor()
    cursor.execute(
        "UPDATE clientes SET nombre = %s, direccion = %s, telefono = %s, cedula = %s WHERE id = %s",
        (nombre, direccion, telefono, cedula, id),
    )
    mysql.connection.commit()
    cursor.close()
    flash("Cliente actualizado correctamente")

    return redirect(url_for("clientes"))


################################## PROVEEDORES ########################################


@app.route("/proveedores", methods=["GET", "POST"])
def proveedores():
    if "loggedin" not in session:
        return redirect(url_for("login"))

    if request.method == "POST":
        nombre = request.form["nombre"]
        direccion = request.form["direccion"]
        rif = request.form["rif"]

        cursor = mysql.connection.cursor(MySQLdb.cursors.DictCursor)
        cursor.execute(
            "INSERT INTO proveedores (nombre, direccion, rif) VALUES (%s, %s, %s)",
            (nombre, direccion, rif),
        )
        mysql.connection.commit()
        cursor.close()
        flash("Proveedor agregado correctamente")

    cursor = mysql.connection.cursor(MySQLdb.cursors.DictCursor)
    cursor.execute("SELECT * FROM proveedores")
    proveedores = cursor.fetchall()
    cursor.close()

    return render_template("proveedores.html", proveedores=proveedores)


@app.route("/eliminar_proveedores", methods=["POST"])
def eliminar_proveedores():
    if "loggedin" not in session:
        return redirect(url_for("login"))

    proveedor_ids = request.form.getlist("proveedor_ids")
    cursor = mysql.connection.cursor()
    for proveedor_id in proveedor_ids:
        cursor.execute("DELETE FROM proveedores WHERE id = %s", (proveedor_id,))
    mysql.connection.commit()
    cursor.close()
    flash("Proveedores eliminados correctamente")

    return redirect(url_for("proveedores"))


##################### OLVIDASTE TU CONTRASEÑA ##########################################


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


################################### TRANSACCIONES #####################################################


@app.route("/transacciones", methods=["GET", "POST"])
def transacciones():
    if "loggedin" not in session:
        return redirect(url_for("login"))

    cursor = mysql.connection.cursor(MySQLdb.cursors.DictCursor)
    cursor.execute("SELECT * FROM transacciones;")
    transacciones = cursor.fetchall()
    for transaccion in transacciones:
        usuario = transaccion["usuarios_id"]
        cursor.execute("SELECT nombre FROM usuarios WHERE id = %s", (usuario,))
        transaccion["usuario"] = cursor.fetchone()["nombre"]

        if transaccion["clientes_id"]:
            cliente = transaccion["clientes_id"]
            cursor.execute("SELECT nombre FROM clientes WHERE id = %s", (cliente,))
            transaccion["cliente"] = cursor.fetchone()["nombre"]
        else:
            proveedor = transaccion["proveedores_id"]
            cursor.execute("SELECT nombre FROM proveedores WHERE id = %s", (proveedor,))
            transaccion["proveedor"] = cursor.fetchone()["nombre"]

    cursor.close()

    return render_template("transacciones.html", transacciones=transacciones)


@app.route("/logout")
def logout():
    session.pop("loggedin", None)
    session.pop("id", None)
    session.pop("username", None)
    session.pop("rol", None)
    return redirect(url_for("login"))


if __name__ == "__main__":
    app.run(debug=True)
