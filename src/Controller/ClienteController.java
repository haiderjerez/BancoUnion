package Controller;

import Model.Conexion.BdConexion;
import Model.Conexion.CRUD;
import static Model.Conexion.CRUD.getConnection;
import bancounion.*;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public abstract class ClienteController {
    public static boolean registrarCliente(String identificacion, String nombre, String apellido, String direccion, String telefono, boolean activo){
        Cliente c1 = new Cliente(identificacion, nombre, apellido, direccion, telefono);
        CRUD.setConnection(BdConexion.ConexionBD());
        
        String insercion = "INSERT INTO Clientes (identificacion, nombre, apellido, direccion, telefono) VALUES (?,?,?,?,?);";
        List<Object> parametros = new ArrayList<>();
        parametros.add(c1.getIdentificacion());
        parametros.add(c1.getNombre());
        parametros.add(c1.getApellido());
        parametros.add(c1.getDireccion());
        parametros.add(c1.getTelefono());
        
        try {
            if (CRUD.setAutoCommitBD(false)) {
                boolean exito = CRUD.insertarBD(insercion, parametros);
                if (exito) {
                    CRUD.commitBD();
                    return true;
                } else {
                    CRUD.rollbackBD();
                    return false;
                }
            } else {
                return false;
            }
        } catch (Exception e) {
            CRUD.rollbackBD();
            throw e;
        } finally {
            CRUD.cerrarConexion();
        }
    }
    public void listarClientes() {
        String sql = "SELECT * FROM Clientes ";
        try (Connection conexion = getConnection();
             PreparedStatement statement = conexion.prepareStatement(sql);
             ResultSet resultSet = statement.executeQuery()) {

            while (resultSet.next()) {
                System.out.println("ID: " + resultSet.getInt("id") + ", Identificacion: " + resultSet.getString("identificacion") + ", Nombre: " + resultSet.getString("nombre") + ", Apellido: " + resultSet.getString("apellido") + ", Direccion: " + resultSet.getString("telefono"));
            }
        } catch (SQLException e) {
            System.err.println("Error al listar clientes: " + e.getMessage());
        }
    }
}



