<%@ page import="com.gmail.kahn.shao.alex.loginstatistic.Users" %>
<%@ page import="com.gmail.kahn.shao.alex.loginstatistic.User" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta http-equiv="X-UA-Compatible" content="ie=edge">
    <title>Java Pro 06.11.23</title>
    <style>
        @import url('https://fonts.googleapis.com/css2?family=Poppins:wght@200;300;400;500;600;700&display=swap');

        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
            font-family: 'Poppins', sans-serif;
        }

        body {
            min-height: 100vh;
            width: 100%;
            background: #009579;
        }

        .container {
            position: absolute;
            top: 50%;
            left: 50%;
            transform: translate(-50%, -50%);
            max-width: 430px;
            width: 100%;
            background: #fff;
            border-radius: 7px;
            box-shadow: 0 5px 10px rgba(0, 0, 0, 0.3);
        }

        .container .registration {
            display: none;
        }

        #check:checked ~ .registration {
            display: block;
        }

        #check:checked ~ .login {
            display: none;
        }

        #check {
            display: none;
        }

        .container .form {
            padding: 2rem;
        }

        .form header {
            font-size: 2rem;
            font-weight: 500;
            text-align: center;
            margin-bottom: 1.5rem;
        }

        .form input {
            height: 60px;
            width: 100%;
            padding: 0 15px;
            font-size: 17px;
            margin-bottom: 1.3rem;
            border: 1px solid #ddd;
            border-radius: 6px;
            outline: none;
        }

        .form input:focus {
            box-shadow: 0 1px 0 rgba(0, 0, 0, 0.2);
        }

        .form a {
            font-size: 16px;
            color: #009579;
            text-decoration: none;
        }

        .form a:hover {
            text-decoration: underline;
        }

        .form input.button {
            color: #fff;
            background: #009579;
            font-size: 1.2rem;
            font-weight: 500;
            letter-spacing: 1px;
            margin-top: 1.7rem;
            cursor: pointer;
            transition: 0.4s;
        }

        .form input.button:hover {
            background: #006653;
        }

        .signup {
            font-size: 17px;
            text-align: center;
        }

        .signup label {
            color: #009579;
            cursor: pointer;
        }

        .signup label:hover {
            text-decoration: underline;
        }
    </style>
</head>
<body>
<% String login = (String) session.getAttribute("user_login"); %>

<% if (login == null || "".equals(login)) { %>
<div class="container">
    <input type="checkbox" id="check">
    <div class="login form">
        <header>Login</header>
        <form action="/login" method="POST">
            <input type="text" placeholder="Enter your login" name="login">
            <input type="password" placeholder="Enter your password" name="password">
            <input type="submit" class="button" value="login" formaction="/login" name="button">
        </form>
        <div class="signup">
        <span class="signup">Don't have an account?
         <label for="check">Signup</label>
        </span>
            <form action="/login" method="POST">
                <input type="submit" class="button" value="statistic" formaction="/login" name="button">
            </form>
        </div>
    </div>
    <div class="registration form">
        <header>Signup</header>
        <form action="/login" method="POST">
            <input type="text" placeholder="Enter your login" name="login">
            <input type="password" placeholder="Create a password" name="password">
            <input type="submit" class="button" value="signup" formaction="/login" name="button">
        </form>
        <div class="signup">
        <span class="signup">Already have an account?
         <label for="check">Login</label>
        </span>
            <form action="/login" method="POST">
                <input type="submit" class="button" value="statistic" formaction="/login" name="button">
            </form>
        </div>
    </div>
</div>
<% } else if (login.equals("statistic")) { %>
<div class="container">
    <div class="form">
        <p class="signup"><b>STATISTIC</b></p>
        <% Users users = (Users) session.getAttribute("users"); %>
        <div style="text-align: center;">Users: <%= users.getUsersCount() %> |
            Logins: <%= users.getUsersLoginsCounter() %>
        </div>
        <% if (users.getUsersCount() > 0) { %>
        <br>
        <table style="border: 1px solid black; margin-left: auto; margin-right: auto; width: 100%">
            <tr>
                <td><b>User</b></td>
                <td style="width: 20%; text-align: center"><b>Logins</b></td>
            </tr>
            <% for (User user : users) { %>
            <tr>
                <td><%= user.getLogin() %>
                </td>
                <td style="text-align: center"><%= user.getLoginsCounter() %>
                </td>
            </tr>
            <% } %>
        </table>
        <br>
        <% } else { %>
        <div style="text-align: center;">No users</div>
        <% } %>
        <div class="signup">
            <span class="signup">Add random user?
            <label for="check"><a href="/login?a=add">Add</a></label>
            </span><br>
            <span class="signup">Do you want to exit?
            <label for="check"><a href="/login?a=exit">Return</a></label>
            </span>
            <% if (users.getUsersCount() > 15) { %>
            <br><span class="signup">Clear list?
            <label for="check"><a href="/login?a=clear">Clear</a></label>
            </span>
            <% } %>
        </div>
    </div>
</div>
<% } else { %>
<div class="container">
    <div class="form">
        <% boolean isWrongLoginOrPassword = login.equals("wrong"); %>
        <% boolean isLoginExists = login.equals("exists"); %>
        <p class="signup"><b>Welcome<%= isLoginExists || isWrongLoginOrPassword ? "" : ", " + login %>!</b></p>
        <% if (!(isLoginExists || isWrongLoginOrPassword)) { %>
        <% Integer loginsCount = (Integer) session.getAttribute("logins_count"); %>
        <div style="text-align: center;"><%= "You were logged in " + loginsCount + " time" + (loginsCount != 1 ? "s" : "") %>
        </div>
        <% } %>
        <div class="signup">
        <span class="signup"><%= isLoginExists ? "Login already exist!" : isWrongLoginOrPassword ? "Wrong login or password " : "Do you want to exit?" %>
            <label for="check"><a
                    href="/login?a=exit"><%= isLoginExists || isWrongLoginOrPassword ? "Return" : "Logout" %></a></label>
        </span>
        </div>
    </div>
</div>
<% } %>
</body>
</html>