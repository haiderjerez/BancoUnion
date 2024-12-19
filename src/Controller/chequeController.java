package Controller;

import static Model.Conexion.CRUD.getConnection;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;


public abstract class chequeController {
    public void agregarCheque(String numeroCheque, String beneficiario, int monto) {
        String sql = "INSERT INTO Cheques (numeroCheque, beneficiario, monto) VALUES (?,?,?)";
        try (Connection conexion = getConnection();
             PreparedStatement statement = conexion.prepareStatement(sql)) {

            statement.setString(1, numeroCheque);
            statement.setString(2, beneficiario);
            statement.setInt(3, monto);
            statement.executeUpdate();
            System.out.println("Cheque agregado correctamente.");
        } catch (SQLException e) {
            System.err.println("Error al agregar cheque: " + e.getMessage());
        }
    }
    public void listarCheques() {
        String sql = "SELECT * FROM Cheques";
        try (Connection conexion = getConnection();
             PreparedStatement statement = conexion.prepareStatement(sql);
             ResultSet resultSet = statement.executeQuery()) {

            while (resultSet.next()) {
                System.out.println("ID: " + resultSet.getInt("ID") + ", Numero del cheque: " + resultSet.getString("numero_cheque") + ", Beneficiario: " + resultSet.getString("beneficiario") + ", Monto: " + resultSet.getString("monto_letra"));
            }
        } catch (SQLException e) {
            System.err.println("Error al listar cheques: " + e.getMessage());
        }
    }
    
}

