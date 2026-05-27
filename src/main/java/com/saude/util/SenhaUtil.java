package com.saude.util;

import org.mindrot.jbcrypt.BCrypt;
import java.util.regex.Pattern;

public class SenhaUtil {

    // Mínimo 8 chars, ao menos 1 letra, 1 número e 1 caractere especial (RF02)
    private static final Pattern FORCA_SENHA = Pattern.compile(
        "^(?=.*[A-Za-z])(?=.*\\d)(?=.*[@$!%*#?&._\\-])[A-Za-z\\d@$!%*#?&._\\-]{8,}$"
    );

    public static String criptografar(String senha) {
        return BCrypt.hashpw(senha, BCrypt.gensalt(12));
    }

    public static boolean verificar(String senha, String hash) {
        return BCrypt.checkpw(senha, hash);
    }

    public static boolean validarForca(String senha) {
        return senha != null && FORCA_SENHA.matcher(senha).matches();
    }
}
