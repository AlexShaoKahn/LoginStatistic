package com.gmail.kahn.shao.alex.loginstatistic;

import java.util.Iterator;
import java.util.Map;
import java.util.TreeMap;

public class Users implements Iterable<User> {
    private final Map<String, User> users;

    public Users() {
        users = new TreeMap<>();
    }

    public void clearUsers() {
        users.clear();
    }

    public void addUser(User user) {
        users.put(user.getLogin(), user);
    }

    public boolean addUser(String login, String password) {
        if (users.containsKey(login)) return false;
        else {
            users.put(login, new User(login, password));
            return true;
        }
    }

    public int getUsersCount() {
        return users.size();
    }

    public int getUsersLoginsCounter() {
        int c = 0;
        for (User user : users.values()) {
            c += user.getLoginsCounter();
        }
        return c;
    }

    public int getUserLoginsCounter(String login, String password) {
        return isExistsUserAndPassword(login, password) ? users.get(login).getLoginsCounter() : 0;
    }

    public void addUserLoginCount(String login, String password) {
        if (isExistsUserAndPassword(login, password)) users.get(login).incLogins();
    }

    public boolean isExistsUserAndPassword(String login, String password) {
        return users.containsKey(login) && users.get(login).isMatchPassword(password);
    }

    @Override
    public Iterator<User> iterator() {
        return users.values().iterator();
    }
}
