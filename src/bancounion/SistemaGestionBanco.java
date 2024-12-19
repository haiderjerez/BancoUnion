package bancounion;

import Model.Conexion.BdConexion;
import Controller.*;

import java.util.*;
import java.util.concurrent.Executors;
import java.util.concurrent.ExecutorService;


public class SistemaGestionBanco {

    public static void main(String[] args) {
        Banco bancoUnion = new Banco("Banco Unión S.A.");
        MenuPrincipal menu = new MenuPrincipal(bancoUnion);
        menu.iniciar();
        BdConexion.ConexionBD();
    }
}

class Banco {
    private String nombre;
    private Map<String, Cliente> clientes;
    private List<Cheque> chequesPendientes;

    public Banco(String nombre) {
        this.nombre = nombre;
        this.clientes = new HashMap<>();
        this.chequesPendientes = new ArrayList<>();
    }

    public String getNombre() {
        return nombre;
    }

    public void agregarCliente(Cliente cliente) {
        clientes.put(cliente.getIdentificacion(), cliente);
    }

    public Cliente buscarCliente(String identificacion) {
        return clientes.get(identificacion);
    }

    public void agregarChequePendiente(Cheque cheque) {
        chequesPendientes.add(cheque);
    }

    public List<Cheque> obtenerChequesPendientes() {
        return chequesPendientes;
    }

}

class Cliente {
    private String identificacion;
    private String nombre;
    private String apellido;
    private String direccion;
    private String telefono;
    private boolean activo;
    private List<Cuenta> cuentas;

    public Cliente(String identificacion, String nombre, String apellido, String direccion, String telefono, boolean activo) {
        this.identificacion = identificacion;
        this.nombre = nombre;
        this.apellido = apellido;
        this.direccion = direccion;
        this.telefono = telefono;
        this.activo = activo;
        this.cuentas = new ArrayList<>();
    }

    public String getIdentificacion() {
        return identificacion;
    }
    
    public void setIdentificacion(String identificaccion){
        this.identificacion = identificacion;
    }

    public String getNombre() {
        return nombre;
    }
    
    public void setNombre(String nombre){
        this.nombre = nombre;
    }
    
    public String getApellido(){
        return apellido;
    }
    
    public void setApellido(){
        this.apellido = apellido;
    }
    
    public String getDireccion(){
        return direccion;
    }
    
    public void setDireccion(){
        this.direccion = direccion;
    }
    
    public String getTelefono(){
        return telefono;
    }
    
    public void setTelefono(){
        this.telefono = telefono;
    }

    public boolean isActivo() {
        return activo;
    }

    public void agregarCuenta(Cuenta cuenta) {
        cuentas.add(cuenta);
    }

    public List<Cuenta> getCuentas() {
        return cuentas;
    }
}

class Cuenta {
    private String tipo;
    private double saldo;
    private double limiteSaldo;
    private boolean activa;

    public Cuenta(String tipo, double saldo, double limiteSaldo, boolean activa) {
        this.tipo = tipo;
        this.saldo = saldo;
        this.limiteSaldo = limiteSaldo;
        this.activa = activa;
    }

    public String getTipo() {
        return tipo;
    }

    public double getSaldo() {
        return saldo;
    }

    public void depositar(double monto) {
        saldo += monto;
    }

    public boolean retirar(double monto) {
        if (saldo >= monto) {
            saldo -= monto;
            return true;
        }
        return false;
    }

    public boolean isActiva() {
        return activa;
    }
}

class Cheque {
    private static int contador = 1000;
    private int numero;
    private String beneficiario;
    private double monto;
    private String prioridad;
    private boolean procesado;

    public Cheque(String beneficiario, double monto, String prioridad) {
        this.numero = contador++;
        this.beneficiario = beneficiario;
        this.monto = monto;
        this.prioridad = prioridad;
        this.procesado = false;
    }

    public int getNumero() {
        return numero;
    }

    public String getBeneficiario() {
        return beneficiario;
    }

    public double getMonto() {
        return monto;
    }

    public String getPrioridad() {
        return prioridad;
    }

    public boolean isProcesado() {
        return procesado;
    }

    public void procesar() {
        this.procesado = true;
    }

    @Override
    public String toString() {
        return String.format("Cheque No: %d\nBeneficiario: %s\nMonto: $%.2f\nPrioridad: %s", 
                numero, beneficiario, monto, prioridad);
    }
}

class MenuPrincipal {
    private Banco banco;
    private Scanner scanner;

    public MenuPrincipal(Banco banco) {
        this.banco = banco;
        this.scanner = new Scanner(System.in);
    }

    public void iniciar() {
        while (true) {
            System.out.println("\n=== Sistema de Gestión Financiera ===");
            System.out.println("1. Agregar Cliente");
            System.out.println("2. Emitir Cheque");
            System.out.println("3. Procesar Cheques Pendientes");
            System.out.println("4. Salir");
            System.out.print("Seleccione una opción: ");
            int opcion = scanner.nextInt();
            scanner.nextLine();

            switch (opcion) {
                case 1 -> agregarCliente();
                case 2 -> emitirCheque();
                case 3 -> procesarCheques();
                case 4 -> {
                    System.out.println("Saliendo del sistema. ¡Hasta luego!");
                    return;
                }
                default -> System.out.println("Opción no válida.");
            }
        }
    }

    private void agregarCliente() {
        System.out.print("Ingrese identificación: ");
        String identificacion = scanner.nextLine();
        System.out.print("Ingrese nombre: ");
        String nombre = scanner.nextLine();
        System.out.print("Ingrese apellido: ");
        String apellido = scanner.nextLine();
        System.out.print("Ingrese direccion: ");
        String direccion = scanner.nextLine();
        System.out.print("Ingrese telefono: ");
        String telefono = scanner.nextLine();
        Cliente cliente = new Cliente(identificacion, nombre, apellido, direccion, telefono, true);
        banco.agregarCliente(cliente);
        System.out.println("Cliente agregado exitosamente.");
    }

    private void emitirCheque() {
        System.out.print("Ingrese identificación del cliente: ");
        String identificacion = scanner.nextLine();
        Cliente cliente = banco.buscarCliente(identificacion);

        if (cliente == null || !cliente.isActivo()) {
            System.out.println("Cliente no encontrado o inactivo.");
            return;
        }

        System.out.print("Ingrese beneficiario: ");
        String beneficiario = scanner.nextLine();
        System.out.print("Ingrese monto: ");
        double monto = scanner.nextDouble();
        scanner.nextLine();
        System.out.print("Ingrese prioridad (Alta, Media, Baja): ");
        String prioridad = scanner.nextLine();

        Cheque cheque = new Cheque(beneficiario, monto, prioridad);
        banco.agregarChequePendiente(cheque);
        System.out.println("Cheque emitido exitosamente: \n" + cheque);
    }

    private void procesarCheques() {
        List<Cheque> chequesPendientes = banco.obtenerChequesPendientes();

        chequesPendientes.sort(Comparator.comparing(Cheque::getPrioridad));// REQ: FUNCION LAMBDA
        ExecutorService executor = Executors.newFixedThreadPool(2); //REQ: HILOS

        for (Cheque cheque : chequesPendientes) {
            executor.execute(() -> {
                System.out.println("Procesando: " + cheque);
                cheque.procesar();
            });
        }

        executor.shutdown();
        System.out.println("Todos los cheques pendientes han sido procesados.");
    }
}