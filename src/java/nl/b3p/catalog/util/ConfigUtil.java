/*
 * Copyright 2009 B3Partners BV
 * 
 */

package nl.b3p.catalog.util;

import javax.servlet.ServletConfig;
import javax.servlet.ServletContext;
import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;

/**
 *
 * @author Erik van de Pol
 */
public class ConfigUtil {
    private final static Log log = LogFactory.getLog(ConfigUtil.class);

    public static String getInitParamValue(ServletConfig config, String parameter, String defaultValue) {
        String tmpval = config.getInitParameter(parameter);
        String retval = getDefaultParamValueIfEmpty(parameter, defaultValue, tmpval);
        log.info("InitParam: " + parameter + " = " + retval);
        return retval;
    }

    public static String getContextParamValue(ServletContext context, String parameter, String defaultValue) {
        String tmpval = context.getInitParameter(parameter);
        String retval = getDefaultParamValueIfEmpty(parameter, defaultValue, tmpval);
        log.info("ContextParam: " + parameter + " = " + retval);
        return retval;
    }

    protected static String getDefaultParamValueIfEmpty(String parameter, String defaultValue, String tmpval) {
        String retval = tmpval;
        if (tmpval == null || tmpval.trim().length() == 0) {
            retval = defaultValue;
        }
        return retval;
    }

}
