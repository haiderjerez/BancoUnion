package Model.Conexion;

import java.sql.Connection;
import java.sql.DatabaseMetaData;
import java.sql.DriverManager;
import java.sql.SQLException;


public abstract class BdConexion {

    private static String url = "";
    public static Connection con = null;
    private static String user = "campus2023";
    private static String password = "campus2023";

    public static Connection ConexionBD() {
        if (con == null) {
            url = "jdbc:mysql://localhost:3306/banco_union";
            try {
                con = DriverManager.getConnection(url, user, password);
                if (con != null) {
                    DatabaseMetaData meta = con.getMetaData();
                    System.out.println("Base de datos conectada: " + meta.getDriverName());
                }
            } catch (SQLException ex) {
                System.out.println("Error al conectar: " + ex.getMessage());
            }
        }
        return con;
    }

    public static void main(String[] args) {
        System.out.println(ConexionBD());
    }
}
