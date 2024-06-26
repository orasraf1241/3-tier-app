from flask import Flask, jsonify
import mysql.connector


def check_db_schema_exists(host, user, password, database):
    # Check if the database schema exists 
    conn = mysql.connector.connect(
        host=host,
        user=user,
        password=password,
    )
    cursor = conn.cursor()
    cursor.execute(f"SELECT SCHEMA_NAME FROM INFORMATION_SCHEMA.SCHEMATA WHERE SCHEMA_NAME = '{database}'")
    existing_db = cursor.fetchone()
    conn.close()
    return existing_db is not None

def create_db_schema(host, user, password, database):
    # Establish the connection and create a database
    conn = mysql.connector.connect(
        host=host,
        user=user,
        password=password,
    )

    # Create a cursor object
    cursor = conn.cursor()

    # Check if the database already exists
    cursor.execute(f"SELECT SCHEMA_NAME FROM INFORMATION_SCHEMA.SCHEMATA WHERE SCHEMA_NAME = '{database}'")
    existing_db = cursor.fetchone()

    if existing_db:
        print(f"The database '{database}' already exists. Exiting.")
        conn.close()
        return

    # Create the database
    cursor.execute(f'CREATE DATABASE {database}')

    # Switch to the database
    cursor.execute(f'USE {database}')

    # Create the table
    cursor.execute('''
        CREATE TABLE python (
            id INT AUTO_INCREMENT PRIMARY KEY,
            column1 VARCHAR(255),
            column2 VARCHAR(255)
        )
    ''')

    # Insert data into the table
    cursor.execute("INSERT INTO python (column1, column2) VALUES (%s, %s)", ('value1', 'value2'))

    # Commit the changes and close the connection
    conn.commit()
    conn.close()



app = Flask(__name__)

@app.route('/', methods=['GET'])
def get_data():
    conn = None  # Initialize conn outside the try block

    try:
        # Establish the connection
        conn = mysql.connector.connect(
            host=db_host,
            user=db_user,
            password=db_password,
            database=db_name
        )

        # Create a cursor object
        cursor = conn.cursor()

        # Execute a sample query (replace with your actual query)
        cursor.execute("SELECT * FROM python")

        # Fetch all rows
        rows = cursor.fetchall()

        # Convert the result to a list of dictionaries
        data = [{'id': row[0], 'column1': row[1], 'column2': row[2]} for row in rows]

        return jsonify(data)

    except Exception as e:
        return jsonify({'error': str(e)})

    finally:
        # Close the connection
        if conn:
            conn.close()


if __name__ == '__main__':
    # Database configuration
    db_host = 'database.terasky-int.com'
    db_user = 'root'
    db_password = 'aXa125690'
    db_name = 'python'

    # Check if the database schema exists
    if not check_db_schema_exists(db_host, db_user, db_password, db_name):
    # If the schema doesn't exist, create it
       create_db_schema(db_host, db_user, db_password, db_name)
    # Run the Flask app
    app.run(debug=True, host="0.0.0.0")