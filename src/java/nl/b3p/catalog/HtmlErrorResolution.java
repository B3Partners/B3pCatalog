/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package nl.b3p.catalog;

import java.io.PrintWriter;
import java.io.StringWriter;
import javax.servlet.http.HttpServletResponse;
import net.sourceforge.stripes.action.StreamingResolution;

/**
 *
 * @author Erik van de Pol
 */
public class HtmlErrorResolution extends StreamingResolution {

    protected final static String DEFAULT_CONTENT_TYPE = "text/html";
    protected final static int DEFAULT_CUSTOM_ERROR_CODE = 1000;

    public HtmlErrorResolution(Exception e) {
        this(null, e);
    }

    public HtmlErrorResolution(Exception e, boolean printStackTrace) {
        this(null, e, printStackTrace);
    }

    public HtmlErrorResolution(String htmlMessage) {
        this(htmlMessage, null);
    }

    public HtmlErrorResolution(String htmlMessage, Exception e) {
        this(htmlMessage, e, true);
    }

    public HtmlErrorResolution(String htmlMessage, Exception e, boolean printStackTrace) {
        super(DEFAULT_CONTENT_TYPE, createHtmlString(htmlMessage, e, printStackTrace));
        setCharacterEncoding("UTF-8");
    }

    private static String createHtmlString(String htmlMessage, Exception e, boolean printStackTrace) {
        StringBuilder sb = new StringBuilder();

        sb.append("<div>");
        
        if (htmlMessage != null) {
            sb.append(htmlMessage);
            if (e != null)
                sb.append(": ");
        }
        
        if (e != null) {
            sb.append(e.getLocalizedMessage());
            if (printStackTrace) {
                sb.append("<br /><br />");
                //sb.append("<script type='text/javascript'>$(document).ready(function(){ $('#advanced-error-button').button().click(function(){ $(\"#advanced-error\").toggle(); }); });</script>");
                sb.append("<a href='#' id='advanced-error-button' onclick='jQuery(\"#advanced-error\").toggle();'>Toon geavanceerde informatie</a>");
                sb.append("<pre id='advanced-error' style='display: none; color: red; background-color: #F0F0F0'>");
                StringWriter sw = new StringWriter();
                e.printStackTrace(new PrintWriter(sw));
                sb.append(sw.getBuffer());
                sb.append("</pre>");
            }
        }

        if (htmlMessage == null && e == null)
            sb.append("An empty error was thrown.");
        
        sb.append("</div>");

        return sb.toString();
    }

    @Override
    protected void stream(HttpServletResponse response) throws Exception {
        super.stream(response);
        response.setStatus(DEFAULT_CUSTOM_ERROR_CODE);
    }
}
