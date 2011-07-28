package nl.b3p.catalog;

import java.io.IOException;
import java.io.OutputStream;
import java.io.StringWriter;
import javax.servlet.ServletConfig;
import javax.servlet.ServletContext;
import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.xml.bind.JAXBException;
import javax.xml.transform.TransformerException;
import nl.b3p.csw.client.CswClient;
import nl.b3p.csw.client.CswRequestCreator;
import nl.b3p.csw.client.InputBySearch;
import nl.b3p.csw.client.OutputBySearch;
import nl.b3p.csw.client.OwsException;
import nl.b3p.csw.server.CswServable;
import nl.b3p.csw.server.GeoNetworkCswServer;
import nl.b3p.catalog.xml.XslHelper;
import org.jdom.Document;
import org.jdom.JDOMException;
import org.jdom.output.XMLOutputter;

/**
 *
 * @author Chris
 */
public class SimpleCswServlet extends HttpServlet {

    private static Log log = null;
    private static String xslPath = null;
    private static String metadataEditorPath = null;
    private static String metadataEditorContextPath = null;

    private static String mdDir = "/scripts/mde";

    @Override
    public void init(ServletConfig config) throws ServletException {
        super.init(config);

        xslPath = config.getServletContext().getRealPath("/xsls") + "/";
        metadataEditorPath = config.getServletContext().getRealPath(mdDir) + "/";
        metadataEditorContextPath = "." + mdDir + "/";

        // Zet de logger
        log = LogFactory.getLog(this.getClass());
        log.info("Initializing SimpleCswServlet");
    }

    /**
     * Processes requests for both HTTP <code>GET</code> and <code>POST</code> methods.
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String q = request.getParameter("q");
        String p = request.getParameter("p");
        String o = request.getParameter("o");
        String s = request.getParameter("s");
        String t = request.getParameter("t");

        String xsl = request.getParameter("x");
        if (xsl == null || xsl.trim().length() == 0) {
            xsl = ConfigUtil.getContextParamValue(getServletContext(), "defaultXsl", "simple-response.xsl");
        }
        String metadataXsl = request.getParameter("mdxsl");

        if (xsl.indexOf("htm") != -1) {
            response.setContentType("text/html;charset=UTF-8");
        } else {
            response.setContentType("text/xml;charset=UTF-8");
        }

        XMLOutputter outputter = new XMLOutputter();
        OutputStream outputStream = response.getOutputStream();

        ServletContext servletContext = getServletContext();

        String cswLoginUrl = ConfigUtil.getContextParamValue(servletContext, "cswLoginUrl", "No Login Url");
        String cswUrl      = ConfigUtil.getContextParamValue(servletContext, "cswUrl", "No Url");
        String cswUsername = ConfigUtil.getContextParamValue(servletContext, "cswUsername", "No user");
        String cswPassword = ConfigUtil.getContextParamValue(servletContext, "cswPassword", "No password");

        CswServable server = new GeoNetworkCswServer(cswLoginUrl, cswUrl, cswUsername, cswPassword);
        CswClient client = new CswClient(server);

        InputBySearch input = new InputBySearch(CswRequestCreator.createCswRequest(q, p, o, s, t));

        try {
            log.debug("Starting Csw Search");
            OutputBySearch output = client.search(input);

            log.debug(outputter.outputString(output.getXml()));

            log.debug("Starting xsl transformation");
            Document transformedXmlDoc = output.getTransformedXml(xslPath + xsl);

            if (transformedXmlDoc.getContentSize() == 0)
                throw new TransformerException("Eerste transformatie resulteert in een leeg document.");

            log.debug("Finished xsl transformation successfully");

            if (metadataXsl != null && metadataXsl.trim().length() > 0) {
                log.debug("Starting second xsl transformation");
                transformedXmlDoc = XslHelper.transform(transformedXmlDoc,
                        metadataEditorPath + metadataXsl,
                        "baseURL", metadataEditorContextPath);

                if (transformedXmlDoc.getContentSize() == 0)
                    throw new TransformerException("Tweede transformatie resulteert in een leeg document.");
                
                log.debug("Finished second xsl transformation succesfully");
            }

            outputter.output(transformedXmlDoc, outputStream);

            // debugging:
            StringWriter stringWriter = new StringWriter();
            outputter.output(transformedXmlDoc, stringWriter);
            log.debug(stringWriter.toString());

            log.debug("Finished Csw Search succesfully");
            
        } catch (JAXBException e) {
            log.error("Exception bij ophalen csw: " + cswUrl, e);
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Fout tijdens het afhandelen van het antwoord: " + e.getClass() + ": " + e.getMessage());
        } catch (JDOMException e) {
            log.error("Exception bij ophalen csw: " + cswUrl, e);
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Fout tijdens het afhandelen van het antwoord: " + e.getClass() + ": " + e.getMessage());
        } catch (IOException e) {
            log.error("Exception bij ophalen csw: " + cswUrl, e);
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Fout tijdens het afhandelen van het antwoord: " + e.getClass() + ": " + e.getMessage());
        } catch (TransformerException e) {
            log.error("Exception bij transformatie csw: " + cswUrl, e);
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Fout tijdens de transformatie van het antwoord: " + e.getClass() + ": " + e.getMessage());
        } catch (OwsException e) {
            log.error("Exception bij afhandelen csw: " + cswUrl, e);
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Fout tijdens het afhandelen van het antwoord: " + e.getClass() + ": " + e.getMessage());
        } finally {
            outputStream.close();
        }
    }

// <editor-fold defaultstate="collapsed" desc="HttpServlet methods. Click on the + sign on the left to edit the code.">
    /**
     * Handles the HTTP <code>GET</code> method.
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    /**
     * Handles the HTTP <code>POST</code> method.
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    /**
     * Returns a short description of the servlet.
     * @return a String containing servlet description
     */
    @Override
    public String getServletInfo() {
        return "Short description";
    }// </editor-fold>
}
