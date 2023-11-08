package com.gmail.kahn.shao.alex.loginstatistic;

import org.apache.commons.codec.digest.DigestUtils;

public class User {
    private final String login;
    private final String password;
    private int loginsCounter;

    public User(String login, String password) {
        this.login = login;
        this.password = DigestUtils.md5Hex(password).toUpperCase();
        this.loginsCounter++;
    }

    public void incLogins() {
        this.loginsCounter++;
    }

    public void incLogins(int c) {
        this.loginsCounter = c;
    }

    public boolean isMatchPassword(String password) {
        return DigestUtils.md5Hex(password).toUpperCase().equals(this.password);
    }

    public String getLogin() {
        return login;
    }

    public int getLoginsCounter() {
        return loginsCounter;
    }
}
