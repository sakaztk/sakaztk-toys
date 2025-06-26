function FindProxyForURL(url, host) {
    var autoproxy = "PROXY proxy1.hoge.com:8080; PROXY proxy2.hoge.com:8080; DIRECT";

    if (isPrivate(host)
     || shExpMatch(host, "hoge1")
     || shExpMatch(host, "sslvpn.hoge.com")
     || shExpMatch(host, "v.hoge.com")){
        return "DIRECT";
    }
        return autoproxy;
}

/* Private Addresses */
function isPrivate(host) {
    return shExpMatch(host, "10.*")
        || shExpMatch(host, "127.*")
        || shExpMatch(host, "169.254.*")
        || shExpMatch(host, "172.16.*")
        || shExpMatch(host, "172.17.*")
        || shExpMatch(host, "172.18.*")
        || shExpMatch(host, "172.19.*")
        || shExpMatch(host, "172.2?.*")
        || shExpMatch(host, "172.30.*")
        || shExpMatch(host, "172.31.*")
        || shExpMatch(host, "192.168.*");
}