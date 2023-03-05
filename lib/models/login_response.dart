 class LoginResponse{
    String idUsuario = "";
    String nombre = "";
    String correo = "";
    String rol = "";
    String tienda = "";
    String nombreTienda = "";
    String token = "";
    // fechaEmision: number;
    // horaEmision: number;
    // horaVencimiento: number;

    LoginResponse({

       required idUsuario,
       required nombre,
       required correo,
      required rol,
       required tienda,
       required nombreTienda,
       required token 

        
    });
}