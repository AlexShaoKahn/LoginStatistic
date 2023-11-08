package com.gmail.kahn.shao.alex.loginstatistic;

import com.google.gson.JsonArray;
import com.google.gson.JsonObject;
import com.google.gson.JsonParser;
import jakarta.servlet.http.*;

import java.io.*;
import java.net.HttpURLConnection;
import java.net.URI;
import java.net.URISyntaxException;
import java.util.Random;

public class LoginServlet extends HttpServlet {
    private final Users users = new Users();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws IOException {
        String login = request.getParameter("login");
        String password = request.getParameter("password");
        String button = request.getParameter("button");

        HttpSession session = request.getSession(true);
        if (isHaveData(login, password) && button.equals("signup")) {
            User user = new User(login, password);
            boolean isUserAdded = users.addUser(login, password);
            session.setAttribute("logins_count", users.getUserLoginsCounter(login, password));
            session.setAttribute("user_login", isUserAdded ? user.getLogin() : "exists");
        } else if (isHaveData(login, password) && button.equals("login")) {
            if (users.isExistsUserAndPassword(login, password)) {
                users.addUserLoginCount(login, password);
                session.setAttribute("user_login", login);
                session.setAttribute("logins_count", users.getUserLoginsCounter(login, password));
            } else session.setAttribute("user_login", "wrong");
        } else if (button.equals("statistic")) {
            session.setAttribute("users", users);
            session.setAttribute("user_login", "statistic");
        }

        response.sendRedirect("index.jsp");
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws IOException {
        String a = request.getParameter("a");
        HttpSession session = request.getSession(false);

        if ("exit".equals(a) && (session != null))
            session.removeAttribute("user_login");
        else if ("add".equals(a) && (session != null)) {
            User user = getRandomUser();
            if (user != null) users.addUser(user);
        } else if ("clear".equals(a) && (session != null))
            users.clearUsers();

        response.sendRedirect("index.jsp");
    }

    private boolean isHaveData(String... params) {
        for (String param : params) {
            if (param == null || param.isEmpty()) return false;
        }
        return true;
    }

    private User getRandomUser() {
        try {
            URI url = new URI("https://randomuser.me/api/");
            HttpURLConnection con = (HttpURLConnection) url.toURL().openConnection();
            con.setRequestMethod("GET");
            BufferedReader in = new BufferedReader(
                    new InputStreamReader(con.getInputStream()));
            String inputLine;
            StringBuilder content = new StringBuilder();
            while ((inputLine = in.readLine()) != null) {
                content.append(inputLine);
            }
            in.close();
            con.disconnect();

            JsonObject jo = JsonParser.parseString(content.toString()).getAsJsonObject();
            JsonArray ja = jo.get("results").getAsJsonArray();
            jo = ja.get(0).getAsJsonObject();
            jo = jo.get("login").getAsJsonObject();
            User user = new User(jo.get("username").getAsString(), jo.get("password").getAsString());
            user.incLogins(new Random().nextInt(20) + 1);
            return user;
        } catch (URISyntaxException | IOException ignored) {
        }
        return null;
    }
}