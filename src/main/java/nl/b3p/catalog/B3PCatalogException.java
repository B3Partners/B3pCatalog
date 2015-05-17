package nl.b3p.catalog;

public class B3PCatalogException extends Exception {

    public B3PCatalogException(Throwable cause) {
        super(cause);
    }

    public B3PCatalogException(String message, Throwable cause) {
        super(message, cause);
    }

    public B3PCatalogException(String message) {
        super(message);
    }

    public B3PCatalogException() {
    }

}
