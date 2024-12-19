package Model.Conexion;


import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;

public abstract class CRUD {

    public static Connection con;
    public static Statement stmt = null;
    public static ResultSet rs = null;

    public static Connection setConnection(Connection connection) {
        CRUD.con = connection;
        return connection;
    }

    //Retornar la conexion
    public static Connection getConnection() {
        return con;
    }

    //Cerrar la conexion
    public static void closeConnection(Connection con) {
        if (con != null) {
            try {
                con.close();
            } catch (SQLException ex) {
                Logger.getLogger(CRUD.class.getName()).log(Level.SEVERE, null, ex);
            }
        }
    }

    public static boolean setAutoCommitBD(boolean parametro) {
        try {
            con.setAutoCommit(parametro);
        } catch (SQLException sqlex) {
            System.out.println("Error al configurar el autoCommit " + sqlex.getMessage());
            return false;
        }
        return true;
    }

    public static void cerrarConexion() {
        closeConnection(con);
    }

    public static boolean commitBD() {
        try {
            con.commit();
            return true;
        } catch (SQLException sqlex) {
            System.out.println("Error al hacer commit " + sqlex.getMessage());
            return false;
        }
    }

    public static boolean rollbackBD() {
        try {
            con.rollback();
            return true;
        } catch (SQLException sqlex) {
            System.out.println("Error al hacer rollback " + sqlex.getMessage());
            return false;
        }
    }

    // CRUD
    public static boolean insertarBD(String sql, List<Object> parametros) {
        try (PreparedStatement prepared = con.prepareStatement(sql)) {
            for (int i = 0; i < parametros.size(); i++) {
                prepared.setObject(i + 1, parametros.get(i));
            }
            int filasAfectadas = prepared.executeUpdate();
            return filasAfectadas > 0;
        } catch (SQLException | RuntimeException sqlex) {
            System.out.println("ERROR EN INSERTARBD: " + sqlex.getMessage());
            return false;
        }
    }

    public static boolean borrarBD(String sql, List<Object> parametros) {
        try (PreparedStatement prepared = con.prepareStatement(sql)) {
            for (int i = 0; i < parametros.size(); i++) {
                prepared.setObject(i + 1, parametros.get(i));
            }
            int filasAfectadas = prepared.executeUpdate();
            return filasAfectadas > 0;
        } catch (SQLException | RuntimeException sqlex) {
            System.out.println("ERROR EN BORRARBD: " + sqlex.getMessage());
            return false;
        }
    }

    public static ResultSet consultarBD(String sql, List<Object> parametros) {
        try {
            PreparedStatement prepared = con.prepareStatement(sql);
            for (int i = 0; i < parametros.size(); i++) {
                prepared.setObject(i + 1, parametros.get(i));
            }
            return prepared.executeQuery();
        } catch (SQLException sqlex) {
            System.out.println("ERROR EN CONSULTARBD: " + sqlex.getMessage());
            return null;
        }
    }

    public static boolean actualizarBD(String sql, List<Object> parametros) {
        try (PreparedStatement prepared = con.prepareStatement(sql)) {
            for (int i = 0; i < parametros.size(); i++) {
                prepared.setObject(i + 1, parametros.get(i));
            }
            int filasAfectadas = prepared.executeUpdate();
            return filasAfectadas > 0;
        } catch (SQLException | RuntimeException sqlex) {
            System.out.println("ERROR EN ACTUALIZARBD: " + sqlex.getMessage());
            return false;
        }
    }
}
