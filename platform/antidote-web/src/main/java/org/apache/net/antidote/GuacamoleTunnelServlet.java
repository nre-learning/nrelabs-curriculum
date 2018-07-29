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
import org.apache.guacamole.servlet.GuacamoleHTTPTunnelServlet;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import org.apache.http.HttpResponse;
import org.apache.http.client.ClientProtocolException;
import org.apache.http.client.HttpClient;
import org.apache.http.client.methods.HttpGet;
import org.apache.http.impl.client.DefaultHttpClient;

import com.google.gson.Gson;
import com.google.gson.GsonBuilder;


class Lab {
    public int LabUUID;
    public int labId;
    public Endpoint[] endpoints = new Endpoint[]{};
    public boolean ready;
}

class Endpoint {
    public String name;
    public String type;
    public String port;
}

public class GuacamoleTunnelServlet
    extends GuacamoleHTTPTunnelServlet {

    @Override
    protected GuacamoleTunnel doConnect(HttpServletRequest request)
        throws GuacamoleException {

        Logger log = Logger.getLogger("com.antidote.servlet");

        // Get device port from request body
        String devicePort = "";
        try {
            BufferedReader reader = request.getReader();
            devicePort = reader.readLine();
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
        guacConfig.setParameter("password", "Password1!");

        // Connect to guacd - everything is hard-coded here.
        GuacamoleSocket socket = new ConfiguredGuacamoleSocket(
                new InetGuacamoleSocket("localhost", 4822),
                guacConfig
        );

        GuacamoleTunnel tunnel = new SimpleGuacamoleTunnel(socket);
        return tunnel;

    }
}
