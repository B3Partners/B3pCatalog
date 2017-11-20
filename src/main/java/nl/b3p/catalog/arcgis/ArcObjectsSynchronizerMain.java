/*
 * Copyright (C) 2011 B3Partners B.V.
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/>.
 */
package nl.b3p.catalog.arcgis;

import java.util.Locale;
import org.apache.commons.cli.*;
import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.apache.log4j.*;

/**
 *
 * @author Matthijs Laan
 */
public class ArcObjectsSynchronizerMain {
    private static Log log;

    public static final String TYPE_FGDB = "fgdb";
    public static final String TYPE_SDE = "sde";
    public static final String TYPE_SDEFILE = "sdefile";

    private static Options buildOptions() {
        Options options = new Options();

        options.addOption(OptionBuilder.withDescription("ArcObjects home directory").withArgName("dir").hasArg().create("home"));
        options.addOption(OptionBuilder.withDescription("fgdb or sde").hasArg().isRequired().create("type"));
        options.addOption(OptionBuilder.withDescription("target dataset").hasArg().isRequired().create("dataset"));
        options.addOption(OptionBuilder.withDescription("SDE connection file").hasArg().create("sdefile"));
        options.addOption(OptionBuilder.withDescription("SDE connection string").hasArg().create("sde"));
        options.addOption(OptionBuilder.withDescription("Read XML metadata document with all elements to synchronise from stdin").create("stdin"));

        return options;
    }

    private static void usage(Options options) {
        HelpFormatter formatter = new HelpFormatter();
        formatter.printHelp(ArcObjectsSynchronizerMain.class.getSimpleName(), options);

        System.err.println("\nTarget dataset format:\n"
                + "type fgdb: <path to fgdb dir>/[<feature dataset name>/]<dataset name>\n"
                + "type sde: [<feature dataset name>/]<dataset name>");
    }

    public static void main(String[] args) throws Exception {
        Logger root = Logger.getRootLogger();
        root.addAppender(new ConsoleAppender(new PatternLayout("%m%n"),ConsoleAppender.SYSTEM_ERR));

        log = LogFactory.getLog(ArcObjectsSynchronizerMain.class);

        Options options = buildOptions();
        CommandLine cl = null;
        try {
            CommandLineParser parser = new PosixParser();

            cl = parser.parse(options, args);
        } catch(ParseException e) {
            System.err.printf(Locale.ENGLISH, "%s\n\n", e.getMessage());
            usage(options);
            System.exit(1);
        }

        try {
            ArcObjectsLinker.link(cl.getOptionValue("home"));

            ArcObjectsInitializer.initializeViewLicense();

            ArcObjectsSynchronizerWorker.synchronize(cl);

            log.info("Completed");
            System.exit(0);
        } catch(Exception e) {
            e.printStackTrace();
            System.exit(1);
        }
    }
}
