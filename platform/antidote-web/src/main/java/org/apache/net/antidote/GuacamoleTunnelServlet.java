package org.apache.guacamole.net.antidote;

import java.util.logging.Logger;
import java.util.Enumeration;
import java.io.BufferedReader;

import javax.servlet.http.HttpServletRequest;
import org.apache.guacamole.GuacamoleException;
import org.apache.guacamole.net.GuacamoleSocket;
import org.apache.guacamole.net.GuacamoleTunnel;
import org.apache.guacamole.net.InetGuacamoleSocket;
import org.apache.guacamole.net.SimpleGuacamoleTunnel;
import org.apache.guacamole.protocol.ConfiguredGuacamoleSocket;
import org.apache.guacamole.protocol.GuacamoleConfiguration;
import org.apache.guacamole.protocol.GuacamoleClientInformation;
import org.apache.guacamole.servlet.GuacamoleHTTPTunnelServlet;

import java.io.BufferedReader;
import java.io.IOException;

public class GuacamoleTunnelServlet
    extends GuacamoleHTTPTunnelServlet {

    @Override
    protected GuacamoleTunnel doConnect(HttpServletRequest request)
        throws GuacamoleException {

        Logger log = Logger.getLogger("com.antidote.servlet");

        String devicePort = "";
        Integer width = 0;
        Integer height = 0;
        try {
            BufferedReader reader = request.getReader();
            String connectData = reader.readLine();

            log.info("Raw connect data: " + connectData);

            String data[]= connectData.split(";");

            devicePort = data[0];
            width = Integer.parseInt(data[1]);
            height = Integer.parseInt(data[2]);

            reader.close();
        } catch (IOException e) {
            log.info("Problem getting device port " + e.getMessage());
        }

        log.info("Configuring Guacamole tunnel");

        // Create configuration
        GuacamoleConfiguration guacConfig = new GuacamoleConfiguration();
        log.info("Incoming device port: " + devicePort);
        guacConfig.setProtocol("ssh");
        guacConfig.setParameter("hostname", "vip.labs.networkreliability.engineering");
        guacConfig.setParameter("port", devicePort);
        guacConfig.setParameter("username", "root");
        guacConfig.setParameter("password", "VR-netlab9");

        // TODO(mierdin): Temporary fix for now, we're passing screen height and width in connection data. Think there should be a better way
        // http://apache-guacamole-general-user-mailing-list.2363388.n4.nabble.com/SSH-size-and-colors-of-canvas-td988.html
        GuacamoleClientInformation clientInfo = new GuacamoleClientInformation();
        clientInfo.setOptimalScreenWidth(width);
        clientInfo.setOptimalScreenHeight(height);

        // Connect to guacd - everything is hard-coded here.
        GuacamoleSocket socket = new ConfiguredGuacamoleSocket(
                new InetGuacamoleSocket("localhost", 4822),
                guacConfig,
                clientInfo
        );

        GuacamoleTunnel tunnel = new SimpleGuacamoleTunnel(socket);
        return tunnel;

    }
}
