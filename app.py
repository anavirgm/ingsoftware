from flask import (
    Flask,
    render_template,
    request,
    redirect,
    url_for,
    flash,
    session,
    send_file,
    json,
)
from werkzeug.utils import secure_filename
from flask_mysqldb import MySQL
from flask_bcrypt import Bcrypt
from fpdf import FPDF
from datetime import datetime

import MySQLdb.cursors
import subprocess
import os
import requests

app = Flask(__name__)
app.config["UPLOAD_FOLDER"] = "uploads"
app.config["REPORTES_FOLDER"] = "reportes"
app.secret_key = "your_secret_key"
bcrypt = Bcrypt(app)

# Crear directorios si no existen
if not os.path.exists(app.config["UPLOAD_FOLDER"]):
    os.makedirs(app.config["UPLOAD_FOLDER"])
if not os.path.exists(app.config["REPORTES_FOLDER"]):
    os.makedirs(app.config["REPORTES_FOLDER"])

app.config["MYSQL_HOST"] = "localhost"
app.config["MYSQL_USER"] = "root"
app.config["MYSQL_PASSWORD"] = ""
app.config["MYSQL_DB"] = "camicandy"

mysql = MySQL(app)
bcrypt = Bcrypt(app)


def get_tasa_bcv():
    return requests.get(
        "https://pydolarvenezuela-api.vercel.app/api/v1/dollar/unit/bcv"
    ).json()["price"]


class PDF(FPDF):
    def __init__(self, title):
        super().__init__()
        self.title = title

    def header(self):
        # Rendering logo:
        self.image("static/imagenes/icons/camidark.png", 10, 1, 50)
        # Setting font: helvetica bold 15
        self.set_font("helvetica", "B", 15)

        # Printing title:
        width = self.get_string_width(self.title) + 6
        # Moving cursor to the right:
        self.set_x((210 - width) / 2)
        self.cell(
            width,
            9,
            self.title,
            border=1,
            align="C",
        )
        # print date and hour
        self.cell(0, 10, f"{datetime.now().strftime('%d-%m-%Y %H:%M:%S')}", 0, 1, "R")
        # Performing a line break:
        self.ln(20)

    def footer(self):
        # Position cursor at 1.5 cm from bottom:
        self.set_y(-15)
        # Setting font: helvetica italic 10
        self.set_font("helvetica", "I", 10)
        # Printing page number:
        self.cell(0, 12, f"Página {self.page_no()}/{{nb}}", align="C")


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
        cursor.execute(
            "SELECT * FROM usuarios WHERE cedula = %s AND status = 1", (username,)
        )
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

        ############### GRÁFICOS
        # Obtener la cantidad de ventas realizadas la última semana
        cursor.execute(
            "SELECT COUNT(*) AS cantidad, DATE(marca_de_tiempo) AS fecha FROM transacciones WHERE (marca_de_tiempo BETWEEN DATE_SUB(NOW(), INTERVAL 1 WEEK) AND NOW()) AND clientes_id IS NOT NULL GROUP BY DATE(marca_de_tiempo) ORDER BY DATE(marca_de_tiempo) ASC;"
        )
        ventas_semana = cursor.fetchall()
        # Formatear las fechas
        for venta in ventas_semana:
            venta["fecha"] = venta["fecha"].strftime("%Y-%m-%d")

        # Obtener el monto total de las transacciones de la última semana
        cursor.execute(
            "SELECT SUM(importe_en_dolares) AS importe_en_dolares, DATE(marca_de_tiempo) AS fecha FROM transacciones WHERE (marca_de_tiempo BETWEEN DATE_SUB(NOW(), INTERVAL 1 WEEK) AND NOW()) AND clientes_id IS NOT NULL GROUP BY DATE(marca_de_tiempo) ORDER BY DATE(marca_de_tiempo) ASC;"
        )
        ingreso_semana = cursor.fetchall()
        for ingreso in ingreso_semana:
            ingreso["fecha"] = ingreso["fecha"].strftime("%Y-%m-%d")
        ########################

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
            ventas_semana=ventas_semana,
            ingreso_semana=ingreso_semana,
            current_page="dashboard",
        )
    return redirect(url_for("login"))


############################# PRODUCTOS ################################
@app.route("/productos", methods=["GET", "POST"])
def productos():
    if "loggedin" not in session:
        return redirect(url_for("login"))

    if request.method == "POST":
        nombre = request.form["nombre"]
        fecha_de_vencimiento = request.form["fecha_de_vencimiento"]
        cantidad_disponible = request.form["cantidad_disponible"]
        precio_en_dolares = request.form["precio_en_dolares"]

        # Validate that none of the values are None
        if (
            nombre
            and fecha_de_vencimiento
            and cantidad_disponible
            and precio_en_dolares
        ):
            cursor = mysql.connection.cursor(MySQLdb.cursors.DictCursor)
            cursor.execute(
                "INSERT INTO productos (nombre, fecha_de_vencimiento, cantidad_disponible, precio_en_dolares, status) VALUES (%s, %s, %s, %s, 1)",
                (
                    nombre,
                    fecha_de_vencimiento,
                    cantidad_disponible,
                    precio_en_dolares,
                ),
            )
            mysql.connection.commit()
            cursor.close()
            flash("Producto agregado correctamente")
        else:
            flash("Por favor, complete todos los campos del formulario")

    cursor = mysql.connection.cursor(MySQLdb.cursors.DictCursor)
    cursor.execute("SELECT * FROM productos WHERE status = %s", (True,))
    all_products = cursor.fetchall()
    cursor.close()

    return render_template(
        "productos.html",
        username=session["username"],
        rol=session["rol"],
        productos=all_products,
        current_page="productos",
    )


@app.route("/insertar_producto", methods=["POST"])
def insertar_producto():
    if "loggedin" in session:
        if request.method == "POST":
            nombre = request.form["nombre"]
            fecha_vencimiento = request.form["fecha_vencimiento"]
            cantidad_disponible = request.form["cantidad_disponible"]
            precio_en_dolares = request.form["precio_en_dolares"]

            cursor = mysql.connection.cursor(MySQLdb.cursors.DictCursor)
            cursor.execute(
                "INSERT INTO productos (nombre, fecha_de_vencimiento, cantidad_disponible, precio_en_dolares) VALUES (%s, %s, %s, %s)",
                (
                    nombre,
                    fecha_vencimiento,
                    cantidad_disponible,
                    precio_en_dolares,
                ),
            )
            mysql.connection.commit()
            cursor.close()
            flash("Producto agregado correctamente")
            return redirect(url_for("productos"))
    return redirect(url_for("login"))


@app.route("/actualizar_producto", methods=["POST"])
def actualizar_producto():
    # Verificar si el usuario está logueado
    if "loggedin" not in session:
        return redirect(url_for("login"))

    # Obtener los datos del formulario
    producto_id = request.form["producto_id_actualizar"]
    nombre = request.form["nombre_actualizar"]
    fecha_de_vencimiento = request.form["fecha_de_vencimiento_actualizar"]
    cantidad_disponible = request.form["cantidad_disponible_actualizar"]
    precio_en_dolares = request.form["precio_en_dolares_actualizar"]

    # Actualizar la información en la base de datos
    cursor = mysql.connection.cursor(MySQLdb.cursors.DictCursor)
    cursor.execute(
        """
        UPDATE productos
        SET nombre = %s, fecha_de_vencimiento = %s, cantidad_disponible = %s,
            precio_en_dolares = %s
        WHERE id = %s
    """,
        (
            nombre,
            fecha_de_vencimiento,
            cantidad_disponible,
            precio_en_dolares,
            producto_id,
        ),
    )
    mysql.connection.commit()
    cursor.close()

    # Redirigir a la página de productos con un mensaje flash
    flash("Producto actualizado correctamente")
    return redirect(url_for("productos"))


@app.route("/eliminar_productos", methods=["POST"])
def eliminar_productos():
    # Verificar si el usuario está logueado
    if "loggedin" not in session:
        return redirect(url_for("login"))

    # Obtener los IDs de los productos a eliminar del formulario
    producto_ids = request.form.getlist("producto_ids")

    # Iterar sobre los IDs de los productos y marcarlos como inactivos en la base de datos
    cursor = mysql.connection.cursor()
    for producto_id in producto_ids:
        cursor.execute(
            "UPDATE productos SET status = %s WHERE id = %s", (False, producto_id)
        )
    mysql.connection.commit()
    cursor.close()

    # Redirigir a la página de productos con un mensaje flash
    flash("Productos eliminados correctamente")
    return redirect(url_for("productos"))


#################################### CLIENTES ################################################


@app.route("/clientes", methods=["GET", "POST"])
def clientes():
    if "loggedin" not in session:
        return redirect(url_for("login"))

    if request.method == "POST":
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
    cursor.execute("SELECT * FROM clientes WHERE status = 1")
    clientes = cursor.fetchall()
    cursor.close()

    return render_template(
        "clientes.html",
        clientes=clientes,
        username=session["username"],
        rol=session["rol"],
        current_page="clientes",
    )


@app.route("/realizar_venta", methods=["GET", "POST"])
def realizar_venta():
    if "loggedin" not in session:
        return redirect(url_for("login"))

    cursor = mysql.connection.cursor(MySQLdb.cursors.DictCursor)

    # Obtener productos activos
    cursor.execute("SELECT * FROM productos WHERE status = 1")
    productos_activos = cursor.fetchall()

    # Obtener clientes activos
    cursor.execute("SELECT * FROM clientes WHERE status = 1")
    clientes_activos = cursor.fetchall()

    # Obtener usuarios activos
    cursor.execute("SELECT * FROM usuarios WHERE status = 1")
    usuarios_activos = cursor.fetchall()

    cursor.close()

    tasa_bcv = get_tasa_bcv()
    today = datetime.now().strftime("%Y-%m-%d %H:%M:%S")

    if request.method == "POST":
        try:
            marca_de_tiempo = request.form["marca_de_tiempo"]
            clientes_id = request.form["clientes_id"]
            usuarios_id = session["id"]
            carrito = json.loads(request.form["carrito"])

            cursor = mysql.connection.cursor(MySQLdb.cursors.DictCursor)

            # Insertar en la tabla transacciones
            cursor.execute(
                """
                INSERT INTO transacciones
                (marca_de_tiempo, tasa_bcv, clientes_id, usuarios_id)
                VALUES (%s, %s, %s, %s)
                """,
                (marca_de_tiempo, tasa_bcv, clientes_id, usuarios_id),
            )
            mysql.connection.commit()

            transaccion_id = cursor.lastrowid

            # Insertar en la tabla transacciones_tiene_productos
            for producto in carrito:
                cursor.execute(
                    """
                    INSERT INTO transacciones_tiene_productos
                    (transacciones_id, productos_id, cantidad)
                    VALUES (%s, %s, %s)
                    """,
                    (transaccion_id, producto["id"], producto["cantidad"]),
                )
                mysql.connection.commit()

            cursor.close()
            flash("Venta realizada correctamente")
            return redirect(url_for("clientes"))

        except Exception as e:
            flash(f"Ocurrió un error: {str(e)}")
            return redirect(url_for("realizar_venta"))

    return render_template(
        "venta.html",
        productos=productos_activos,
        clientes=clientes_activos,
        usuarios=usuarios_activos,
        username=session["username"],
        rol=session["rol"],
        tasa_bcv=tasa_bcv,
        today=today,
        usuario=session["username"],
        current_page="clientes",
    )


@app.route("/actualizar_cliente", methods=["POST"])
def actualizar_cliente():
    if "loggedin" not in session:
        return redirect(url_for("login"))

    cliente_id = request.form["cliente_id_actualizar"]
    nombre = request.form["nombre_actualizar"]
    direccion = request.form["direccion_actualizar"]
    telefono = request.form["telefono_actualizar"]
    cedula = request.form["cedula_actualizar"]

    cursor = mysql.connection.cursor(MySQLdb.cursors.DictCursor)
    cursor.execute(
        """
        UPDATE clientes
        SET nombre = %s, direccion = %s, telefono = %s, cedula = %s
        WHERE id = %s
    """,
        (nombre, direccion, telefono, cedula, cliente_id),
    )
    mysql.connection.commit()
    cursor.close()

    flash("Cliente actualizado correctamente")
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


################################## PROVEEDORES ########################################


@app.route("/proveedores", methods=["GET", "POST"])
def proveedores():
    if "loggedin" not in session or session["rol"] != "administrador":
        return redirect(url_for("dashboard"))

    if request.method == "POST":
        nombre = request.form["nombre"]
        direccion = request.form["direccion"]
        rif = request.form["rif"]

        cursor = mysql.connection.cursor(MySQLdb.cursors.DictCursor)
        cursor.execute(
            "INSERT INTO proveedores (nombre, direccion, rif, status) VALUES (%s, %s, %s, 1)",
            (nombre, direccion, rif),
        )
        mysql.connection.commit()
        cursor.close()
        flash("Proveedor añadido correctamente", "success")
        return redirect(url_for("proveedores"))

    cursor = mysql.connection.cursor(MySQLdb.cursors.DictCursor)
    cursor.execute("SELECT * FROM proveedores WHERE status = 1")
    proveedores = cursor.fetchall()
    cursor.close()

    return render_template(
        "proveedores.html",
        proveedores=proveedores,
        username=session["username"],
        rol=session["rol"],
        current_page="proveedores",
    )


@app.route("/realizar_compra", methods=["GET", "POST"])
def realizar_compra():
    if "loggedin" not in session:
        return redirect(url_for("login"))

    cursor = mysql.connection.cursor(MySQLdb.cursors.DictCursor)

    # Obtener productos activos
    cursor.execute("SELECT * FROM productos WHERE status = 1")
    productos_activos = cursor.fetchall()

    # Obtener clientes activos
    cursor.execute("SELECT * FROM proveedores WHERE status = 1")
    proveedores_activos = cursor.fetchall()

    # Obtener usuarios activos
    cursor.execute("SELECT * FROM usuarios WHERE status = 1")
    usuarios_activos = cursor.fetchall()

    cursor.close()

    tasa_bcv = get_tasa_bcv()
    today = datetime.now().strftime("%Y-%m-%d %H:%M:%S")

    if request.method == "POST":
        try:
            marca_de_tiempo = request.form["marca_de_tiempo"]
            proveedores_id = request.form["proveedores_id"]
            usuarios_id = session["id"]
            carrito = json.loads(request.form["carrito"])

            cursor = mysql.connection.cursor(MySQLdb.cursors.DictCursor)

            # Insertar en la tabla transacciones
            cursor.execute(
                """
                INSERT INTO transacciones
                (marca_de_tiempo, tasa_bcv, proveedores_id, usuarios_id)
                VALUES (%s, %s, %s, %s)
                """,
                (marca_de_tiempo, tasa_bcv, proveedores_id, usuarios_id),
            )
            mysql.connection.commit()

            transaccion_id = cursor.lastrowid

            # Insertar en la tabla transacciones_tiene_productos
            for producto in carrito:
                cursor.execute(
                    """
                    INSERT INTO transacciones_tiene_productos
                    (transacciones_id, productos_id, cantidad)
                    VALUES (%s, %s, %s)
                    """,
                    (transaccion_id, producto["id"], producto["cantidad"]),
                )

            mysql.connection.commit()  # Commit final después del bucle

            cursor.close()
            flash("Compra realizada correctamente")
            return redirect(url_for("proveedores"))

        except Exception as e:
            flash(f"Ocurrió un error: {str(e)}")
            return redirect(url_for("realizar_compra"))

    return render_template(
        "compras.html",
        productos=productos_activos,
        proveedores=proveedores_activos,
        usuarios=usuarios_activos,
        username=session["username"],
        rol=session["rol"],
        tasa_bcv=tasa_bcv,
        today=today,
        usuario=session["username"],
        current_page="proveedores",
    )


@app.route("/actualizar_proveedor", methods=["POST"])
def actualizar_proveedor():
    # Verificar si el usuario está logueado
    if "loggedin" not in session:
        return redirect(url_for("login"))

    # Obtener los datos del formulario
    proveedor_id = request.form["proveedor_id_actualizar"]
    nombre = request.form["nombre_actualizar"]
    direccion = request.form["direccion_actualizar"]
    rif = request.form["rif_actualizar"]

    # Actualizar la información en la base de datos
    cursor = mysql.connection.cursor(MySQLdb.cursors.DictCursor)
    cursor.execute(
        """
        UPDATE proveedores
        SET nombre = %s, direccion = %s, rif = %s
        WHERE id = %s
    """,
        (nombre, direccion, rif, proveedor_id),
    )
    mysql.connection.commit()
    cursor.close()

    # Redirigir a la página de proveedores con un mensaje flash
    flash("Proveedor actualizado correctamente")
    return redirect(url_for("proveedores"))


@app.route("/eliminar_proveedores", methods=["POST"])
def eliminar_proveedores():
    # Verificar si el usuario está logueado
    if "loggedin" not in session:
        return redirect(url_for("login"))

    # Obtener los IDs de los proveedores a eliminar del formulario
    proveedor_ids = request.form.getlist("proveedor_ids")

    # Iterar sobre los IDs de los proveedores y marcarlos como inactivos en la base de datos
    cursor = mysql.connection.cursor()
    for proveedor_id in proveedor_ids:
        cursor.execute(
            "UPDATE proveedores SET status = %s WHERE id = %s", (False, proveedor_id)
        )
    mysql.connection.commit()
    cursor.close()

    # Redirigir a la página de proveedores con un mensaje flash
    flash("Proveedores eliminados correctamente")
    return redirect(url_for("proveedores"))


##################### OLVIDASTE TU CONTRASEÑA ##########################################


@app.route("/recuperar_contrasena", methods=["GET", "POST"])
def recuperar_contrasena():
    if request.method == "POST" and "username" in request.form:
        username = request.form["username"]

        cursor = mysql.connection.cursor(MySQLdb.cursors.DictCursor)
        cursor.execute(
            "SELECT pregunta_seguridad FROM usuarios WHERE cedula = %s AND status = 1",
            (username,),
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
        cursor.execute(
            "SELECT * FROM usuarios WHERE cedula = %s AND status = 1;", (username,)
        )
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

    transacciones = sorted(
        transacciones, key=lambda x: x["marca_de_tiempo"], reverse=True
    )
    cursor.close()

    return render_template(
        "transacciones.html",
        username=session["username"],
        rol=session["rol"],
        transacciones=transacciones,
        current_page="transacciones",
    )


################################### REPORTES ##########################################


@app.route("/reportes")
def reportes():
    if "loggedin" in session and session["rol"] == "administrador":
        return render_template(
            "reportes.html",
            username=session["username"],
            rol=session["rol"],
            reportes=reportes,
            current_page="reportes",
        )

    return redirect(url_for("dashboard"))


################################### HERRAMIENTAS ######################################


@app.route("/herramientas")
def herramientas():
    if "loggedin" not in session or session["rol"] != "administrador":
        return redirect(url_for("dashboard"))

    return render_template(
        "herramientas.html",
        username=session["username"],
        rol=session["rol"],
        herramientas=herramientas,
        current_page="herramientas",
    )


@app.route("/agregar_empleado", methods=["GET", "POST"])
def agregar_empleado():
    if request.method == "POST":

        cedula = request.form["cedula"]
        nombre = request.form["nombre"]
        rol = request.form["rol"]
        hash_de_contrasena = bcrypt.generate_password_hash(
            request.form["hash_contrasena"]
        ).decode(
            "utf-8"
        )  # Hashear la contraseña
        pregunta_seguridad = request.form["pregunta_seguridad"]
        respuesta_seguridad = bcrypt.generate_password_hash(
            request.form["respuesta_seguridad"]
        ).decode("utf-8")

        # agregar el empleado a la base
        cursor = mysql.connection.cursor(MySQLdb.cursors.DictCursor)
        cursor.execute(
            "INSERT INTO usuarios (cedula, nombre, rol, hash_de_contrasena, pregunta_seguridad, respuesta_seguridad, status) VALUES (%s, %s, %s, %s, %s, %s, 1)",
            (
                cedula,
                nombre,
                rol,
                hash_de_contrasena,
                pregunta_seguridad,
                respuesta_seguridad,
            ),
        )
        mysql.connection.commit()
        cursor.close()

        flash("Empleado agregado correctamente")
        return redirect(url_for("herramientas"))

    return render_template("herramientas.html")


@app.route("/actualizar_empleado", methods=["POST"])
def actualizar_empleado():
    if "loggedin" not in session:
        return redirect(url_for("login"))

    empleado_id = request.form.get(
        "id_empleado"
    )  # Asumiendo que el ID del empleado está en el formulario
    cedula = request.form["cedula"]
    nombre = request.form["nombre"]
    rol = request.form["rol"]
    hash_contrasena = bcrypt.generate_password_hash(
        request.form["hash_contrasena"]
    ).decode(
        "utf-8"
    )  # Hashear la contraseña
    pregunta_seguridad = request.form["pregunta_seguridad"]
    respuesta_seguridad = bcrypt.generate_password_hash(
        request.form["respuesta_seguridad"]
    ).decode("utf-8")

    # Conectar a la base de datos y ejecutar la actualización
    try:
        cursor = mysql.connection.cursor()
        cursor.execute(
            """
            UPDATE usuarios
            SET cedula = %s, nombre = %s, rol = %s, hash_de_contrasena = %s, pregunta_seguridad = %s, respuesta_seguridad = %s
            WHERE id = %s
            """,
            (
                cedula,
                nombre,
                rol,
                hash_contrasena,
                pregunta_seguridad,
                respuesta_seguridad,
                empleado_id,
            ),
        )
        mysql.connection.commit()
        cursor.close()

        flash("Empleado actualizado correctamente", "success")
        return redirect(url_for("herramientas"))

    except MySQLdb.Error as e:
        flash(f"Error al actualizar empleado: {str(e)}", "error")
        return redirect(
            url_for("herramientas")
        )  # Puedes redirigir a donde sea necesario en caso de error

    finally:
        cursor.close()


@app.route("/listar_empleados", methods=["GET", "POST"])
def listar_empleados():
    if "loggedin" not in session:
        return redirect(url_for("login"))

    cursor = mysql.connection.cursor(MySQLdb.cursors.DictCursor)

    if request.method == "POST" and "buscar_empleado" in request.form:
        termino_busqueda = request.form["buscar_empleado"]
        query = """
            SELECT * FROM usuarios
            WHERE rol = 'empleado' AND status = 1
            AND (id LIKE %s OR nombre LIKE %s OR cedula LIKE %s);
        """
        cursor.execute(
            query,
            (
                "%" + termino_busqueda + "%",
                "%" + termino_busqueda + "%",
                "%" + termino_busqueda + "%",
            ),
        )
    else:
        query = "SELECT * FROM usuarios WHERE rol = 'empleado' AND status = 1;"
        cursor.execute(query)

    empleados = cursor.fetchall()
    cursor.close()

    return render_template(
        "herramientas.html",
        username=session.get("username"),
        rol=session.get("rol"),
        empleados=empleados,
    )


@app.route("/respaldar_base", methods=["POST"])
def respaldar_base():
    NOMBRE = "camicandy.sql"

    base = subprocess.run(
        ["C:\\xampp\\mysql\\bin\\mysqldump.exe", "camicandy", "-u", "root"],
        capture_output=True,
        text=True,
    ).stdout

    # with open(NOMBRE, mode="w") as f:
    #    f.write(base)

    return send_file(NOMBRE, as_attachment=True)


@app.route("/recuperar_base", methods=["POST"])
def recuperar_base():
    if request.method == "GET":
        return redirect(url_for("herramientas"))
    else:
        if "file" not in request.files:
            flash("No file part", "danger")
            return redirect(url_for("herramientas"))
        file = request.files["file"]
        if file.filename == "":
            flash("No selected file", "danger")
            return redirect(request.url)

        if file and file.filename.rsplit(".", 1)[1].lower() == "sql":
            filename = secure_filename(file.filename)
            filepath = os.path.join(app.config["UPLOAD_FOLDER"], filename)
            file.save(filepath)
            flash("File uploaded", "success")

            try:
                # Dropear db vieja
                subprocess.run(
                    [
                        "C:\\xampp\\mysql\\bin\\mysqladmin.exe",
                        "-f",
                        "-u",
                        "root",
                        "drop",
                        "camicandy",
                    ],
                    check=True,
                )

                # Crear db de nuevo
                subprocess.run(
                    [
                        "C:\\xampp\\mysql\\bin\\mysqladmin.exe",
                        "-u",
                        "root",
                        "create",
                        "camicandy",
                    ],
                    check=True,
                )

                # Restaurar db
                abs_filepath = os.path.abspath(filepath)
                with open(abs_filepath, "r") as file:
                    subprocess.run(
                        ["C:\\xampp\\mysql\\bin\\mysql.exe", "-u", "root", "camicandy"],
                        stdin=file,
                        check=True,
                    )

                flash("Database restored successfully", "success")
            except subprocess.CalledProcessError as e:
                flash(f"An error occurred: {e}", "error")
                return redirect(url_for("herramientas"))

            # Mantenerse en la sección de herramientas
            return redirect(url_for("herramientas"))
        else:
            flash("Invalid file type", "danger")
            return redirect(request.url)


@app.route("/buscar_productos", methods=["GET"])
def buscar_productos():
    if "loggedin" not in session:
        return redirect(url_for("login"))

    criterio = request.args.get("criterio", "")

    cursor = mysql.connection.cursor(MySQLdb.cursors.DictCursor)
    cursor.execute(
        "SELECT * FROM productos WHERE nombre LIKE %s AND status = %s",
        ("%" + criterio + "%", True),
    )
    productos = cursor.fetchall()
    cursor.close()

    return render_template(
        "venta.html",
        productos=productos,
        username=session["username"],
        rol=session["rol"],
    )


@app.route("/logout")
def logout():
    session.pop("loggedin", None)
    session.pop("id", None)
    session.pop("username", None)
    session.pop("rol", None)
    return redirect(url_for("login"))


@app.errorhandler(404)
def page_not_found(e):
    return redirect(url_for("dashboard"))


# CREACION DE REPORTES
############################################
############################################
############################################
############################################
############################################


@app.route("/productos_reporte", methods=["GET"])
def productos_reporte():
    cursor = mysql.connection.cursor(MySQLdb.cursors.DictCursor)
    cursor.execute("SELECT * FROM productos")
    productos = cursor.fetchall()
    cursor.close()

    if not productos:
        flash("No existen registros en la base de datos")
        return redirect(url_for("reportes"))

    # init pdf engine
    pdf = PDF(title="Reporte de productos")
    pdf.add_page()
    pdf.set_font("Times", size=14)

    # format data
    for producto in productos:
        producto["precio_en_bolivares"] = float(
            f"{float(producto['precio_en_dolares']) * get_tasa_bcv():,.2f}"
        )
        producto["status"] = "Activo" if producto["status"] else "Inactivo"
        producto["cantidad_disponible"] = f"{producto['cantidad_disponible']} unidades"
        producto["precio_en_bolivares"] = f"Bs. {producto['precio_en_bolivares']}"
        producto["precio_en_dolares"] = f"${producto['precio_en_dolares']}"
        producto["fecha_de_vencimiento"] = producto["fecha_de_vencimiento"].strftime(
            "%Y-%m-%d"
        )

    # order of columns in table
    desired_order = {
        "nombre": "Nombre",
        "cantidad_disponible": "Cantidad disponible",
        "precio_en_dolares": "Precio en dólares",
        "precio_en_bolivares": "Precio en bolívares",
        "fecha_de_vencimiento": "Fecha de vencimiento",
        "status": "Estado",
    }
    ordered_productos = [
        {desired_order[key]: producto[key] for key in desired_order}
        for producto in productos
    ]

    # create report
    with pdf.table() as table:
        # header
        header_row = table.row()
        for cell in desired_order.values():
            header_row.cell(
                str(cell),
                align="C",
            )

        # content
        for data_row in ordered_productos:
            row = table.row()
            for i, datum in enumerate(data_row):
                # imprimir el nombre del producto en negrita y a la izquierda
                if i == 0:
                    pdf.set_font("Times", "B", 14)
                    row.cell(
                        str(data_row[datum]),
                        align="L",
                    )
                    pdf.set_font("Times", size=14)
                else:
                    row.cell(
                        str(data_row[datum]),
                        align="R",
                    )

    # save report
    filename = f"{datetime.now().strftime('%Y-%m-%d')}_productos.pdf"
    filepath = f"{app.config['REPORTES_FOLDER']}/{filename}"
    pdf.output(filepath)

    return send_file(filepath, as_attachment=True, mimetype="application/pdf")


@app.route("/clientes_reporte", methods=["GET"])
def clientes_reporte():
    cursor = mysql.connection.cursor(MySQLdb.cursors.DictCursor)
    cursor.execute("SELECT * FROM clientes")
    clientes = cursor.fetchall()
    cursor.close()

    if not clientes:
        flash("No existen registros en la base de datos")
        return redirect(url_for("reportes"))

    # init pdf engine
    pdf = PDF(title="Reporte de clientes")
    pdf.add_page()
    pdf.set_font("Times", size=14)

    # format data
    for cliente in clientes:
        cliente["status"] = "Activo" if cliente["status"] else "Inactivo"

    # order of columns in table
    desired_order = {
        "nombre": "Nombre",
        "cedula": "Cédula",
        "direccion": "Dirección",
        "telefono": "Teléfono",
        "status": "Estado",
    }
    ordered_clientes = [
        {desired_order[key]: cliente[key] for key in desired_order}
        for cliente in clientes
    ]

    # create report
    with pdf.table() as table:
        # header
        header_row = table.row()
        for cell in desired_order.values():
            header_row.cell(
                str(cell),
                align="C",
            )

        # content
        for data_row in ordered_clientes:
            row = table.row()
            for i, datum in enumerate(data_row):
                # imprimir el nombre del cliente en negrita y a la izquierda
                if i == 0:
                    pdf.set_font("Times", "B", 14)
                    row.cell(
                        str(data_row[datum]),
                        align="L",
                    )
                    pdf.set_font("Times", size=14)
                else:
                    row.cell(
                        str(data_row[datum]),
                        align="R",
                    )

    # save report
    filename = f"{datetime.now().strftime('%Y-%m-%d')}_clientes.pdf"
    filepath = f"{app.config['REPORTES_FOLDER']}/{filename}"
    pdf.output(filepath)

    return send_file(filepath, as_attachment=True, mimetype="application/pdf")


@app.route("/proveedores_reporte", methods=["GET"])
def proveedores_reporte():
    cursor = mysql.connection.cursor(MySQLdb.cursors.DictCursor)
    cursor.execute("SELECT * FROM proveedores")
    proveedores = cursor.fetchall()
    cursor.close()

    if not proveedores:
        flash("No existen registros en la base de datos")
        return redirect(url_for("reportes"))

    # init pdf engine
    pdf = PDF(title="Reporte de proveedores")
    pdf.add_page()
    pdf.set_font("Times", size=14)

    # format data
    for proveedor in proveedores:
        proveedor["status"] = "Activo" if proveedor["status"] else "Inactivo"

    # order of columns in table
    desired_order = {
        "nombre": "Nombre",
        "rif": "RIF",
        "direccion": "Dirección",
        "status": "Estado",
    }
    ordered_clientes = [
        {desired_order[key]: proveedor[key] for key in desired_order}
        for proveedor in proveedores
    ]

    # create report
    with pdf.table() as table:
        # header
        header_row = table.row()
        for cell in desired_order.values():
            header_row.cell(
                str(cell),
                align="C",
            )

        # content
        for data_row in ordered_clientes:
            row = table.row()
            for i, datum in enumerate(data_row):
                # imprimir el nombre del cliente en negrita y a la izquierda
                if i == 0:
                    pdf.set_font("Times", "B", 14)
                    row.cell(
                        str(data_row[datum]),
                        align="L",
                    )
                    pdf.set_font("Times", size=14)
                else:
                    row.cell(
                        str(data_row[datum]),
                        align="R",
                    )

    # save report
    filename = f"{datetime.now().strftime('%Y-%m-%d')}_proveedores.pdf"
    filepath = f"{app.config['REPORTES_FOLDER']}/{filename}"
    pdf.output(filepath)

    return send_file(filepath, as_attachment=True, mimetype="application/pdf")


@app.route("/usuarios_reporte", methods=["GET"])
def usuarios_reporte():
    cursor = mysql.connection.cursor(MySQLdb.cursors.DictCursor)
    cursor.execute("SELECT * FROM usuarios")
    usuarios = cursor.fetchall()
    cursor.close()

    if not usuarios:
        flash("No existen registros en la base de datos")
        return redirect(url_for("reportes"))

    # init pdf engine
    pdf = PDF(title="Reporte de usuarios")
    pdf.add_page()
    pdf.set_font("Times", size=14)

    # format data
    for usuario in usuarios:
        usuario["status"] = "Activo" if usuario["status"] else "Inactivo"

    # order of columns in table
    desired_order = {
        "nombre": "Nombre",
        "cedula": "Cédula",
        "rol": "Rol",
        "status": "Estado",
    }
    ordered_clientes = [
        {desired_order[key]: usuario[key] for key in desired_order}
        for usuario in usuarios
    ]

    # create report
    with pdf.table() as table:
        # header
        header_row = table.row()
        for cell in desired_order.values():
            header_row.cell(
                str(cell),
                align="C",
            )

        # content
        for data_row in ordered_clientes:
            row = table.row()
            for i, datum in enumerate(data_row):
                # imprimir el nombre del cliente en negrita y a la izquierda
                if i == 0:
                    pdf.set_font("Times", "B", 14)
                    row.cell(
                        str(data_row[datum]),
                        align="L",
                    )
                    pdf.set_font("Times", size=14)
                else:
                    row.cell(
                        str(data_row[datum]),
                        align="R",
                    )

    # save report
    filename = f"{datetime.now().strftime('%Y-%m-%d')}_usuarios.pdf"
    filepath = f"{app.config['REPORTES_FOLDER']}/{filename}"
    pdf.output(filepath)

    return send_file(filepath, as_attachment=True, mimetype="application/pdf")


if __name__ == "__main__":
    app.run(debug=True)
