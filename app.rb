require 'sinatra'
require "sinatra/reloader"
require 'rest-client'
require 'json'
require 'httparty'
require 'nokogiri'
require 'uri'
require 'date'
require 'csv'

before do
    p "***************"
    p params
    p request.path_info #사용자가 요청보낸 경로
    p request.fullpath #파라미터
    p"***************"
end


get '/' do
  'Hello world! Welcome~~~'
end

get '/htmlfile' do
    send_file 'views/htmlfile.html'
end

get '/htmltag' do
    '<h1>html태그를 보낼 수 있습니다. </h1>
    <ul>
        <li>1</li>
        <li>22</li>
        <li>22</li>
    </ul>'
end

get '/welcome/:name' do
    #여기선 반드시 ""사용해야함.
    "#{params[:name]}님 안녕하세요"
end

get '/cube/:num' do
    # input = params[:num].to_i
    # result = input ** 3
    # "<h1>#{result}</h1>"
    
    "#{params[:num].to_i ** 3}"
    
end

get '/erbfile' do
   @name = "hihi"
   erb :erbfile
end

get '/lunch-array' do
   menu = ["20층", "카페마마스", "김남완초밥", "GS"]
   @lunch = menu.sample
   erb :lunch
end

get '/lunch-hash' do
   #메뉴들이 저장된 배열을 만든다.
   menu = ["카페마마스", "김남완초밥", "GS"]
   
   #메뉴 이름(key) 사진url(value)를 가진 Hash를 만든다.
   menu_img = {
       "카페마마스" => "data:image/jpeg;base64,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",
       "김남완초밥" => "data:image/jpeg;base64,/9j/4AAQSkZJRgABAQAAAQABAAD/2wCEAAkGBxMTEhUTExMWFhUXGB0aFxgYGRgYGhgYGBcYGBgdGx0dHSggGhslGxcYITEhJSkrLi4uFx8zODMtNygtLisBCgoKDg0OFxAPGi0dHx0tLS0tLS0tLS0tLS0tLS0tLS0tLSstLS0rLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLf/AABEIAKMBNgMBIgACEQEDEQH/xAAcAAAABwEBAAAAAAAAAAAAAAAAAQIDBAUGBwj/xABBEAABAwIDBQUGBAUDAgcAAAABAAIRAyEEMUEFElFhcQaBkaHwEyIyscHRBxRC4SNScqLxFWKCkrIzQ1NjwtLi/8QAGQEBAQEBAQEAAAAAAAAAAAAAAAECAwQF/8QAKhEAAgIBBAAEBgMBAAAAAAAAAAECEQMEEiExEyJBUQUUYXGRoTKB8DP/2gAMAwEAAhEDEQA/AOsAlCEM0TRw+SABI6npklpI1siHL1CAUCjN9P2QCIoBcog7SO/1dAdEc+igABwR6zCIoIA0YKNIvn4+SAXn1QJ8UU3RRfmgFX4aIwEQlGAgDJREWRN4pQcgBPBH5ouaFkAchGSkNCMG2SoBu9/FGBwQm6Dj+yAOUTkYROcgFA+KIIIigDIQRH0EolAAFEDzRacEO9AKCKIQSXIBU+ijOaQURMfvZAKmbfZA/RFKAd496AS5veglOcghCIRw8YRgohbj9UrvWShNIhHHVE0epQDlQHvcUZB9ZogeKNoOv+VAGCevkia68a+V/qgTMI2k8++EAc3+SBNkEQKoFgaouQREX5ow70OKAMBEOpQCNAHyt80YEBJyug52aAXKID0UAf3SQTOVkA566IhkkkoyUAbbWzR36pIGSMEc0ADKOOGZ8kl3Hn5InVEAsc0Z9c0kZog66oFg+u5E13ikVHgCTaOJ+sqJW2tQb/5re73vkgJzShU9dFSVO09EfCHO5wB81Crdqz+mmB/UZ8gAlMlo1KAJ4Kq2HtYVhBEPGYGUcQrRChWlG7ohKSDp69fdAKBQn1wSRnOeSMHvUAaI6pOfVGXD91QC6CBsgoCIL5hGB1SSCPqlE9/1QBg68fV0e6k6Z+vqj+aABdqbI3ug5cPOyD380A4C32UAoi8oIj69aIHx8EAoIon1dBpPBFHcgFkobyT1QBP+L6IBwQiBSQ6EZPooBSS42sQETnACSY68foo3+p0pj2jZ0AIcfBslUEwHvQBUN2Oid2nVd/xj/uIWe2v22bQMOoP0FyM54iWjvIWZSUew+DXE2RArBU+2dSqJpBoHQuI6nJSdnVsZiTIqlrNXWaO6ACT6lWLUlaZlO+jZvdbQdVFqbUos+Kq2f6gSo1LZFGAHg1Dq57nEnzskHYGFP6I6Od903I1TCqdp6AyLnHk038YRDblRw9ygernBvknaGwcO0y0OB5umPEJrE7Dm7ap6H7j7LGScl/FWd8OPG/8ApKhr8ziXa02dAXHzTNWjiHfFWf8A8QG/IqLitm1qd828iT+/koTcZWb+rzd9l45aucX5lR9COjwyXlkmSq2yBPvVHydSyfPeTDtlH9L2nrLfnqlt2/VbZzS7ukfOfFOUu1FORvtDSc9D5rS1v1/RH8NtcRv7MrauGe3Np65jxFkyr385Se/+HU3ehHmAir7ODhkA7QjI9Rp1C9GPVKTpnlzaCUVcfwyqweIdTeHtMEH13Ld7NxrarA4d44HgsDUpFpgiCp2yseaL5F2n4hxH3C9LV9Hh5Tpm4JsgDrNkmjVDmhzTY3CA4n15LJoXHFJLu6UaLh0yUApyTHh6/ZG3JC6oDB0QSedxyQQEVvHxzSh09c02zTjrFh80tZAbr2RiVWV9vYZk7+IpjlIJEchfNVtbtvgwIDnv/pYcu+ArQNI3wjvRysbX/EKkPgovP9Ra35byr6vb+q4/w6NME8d558iFdrJZ0PXJIafXrRY/Bv2pXuXNotPFoB7hBd4wrmjsCR/GxFaqdffLG9zW/crL4KizfimAe+Q3+ogfNRMRt/CszrMnXd975SoNTsZhXaVGniHyf7gU07sJh4tUqg8SWHy3ETiGmKrds8OLN33cIbn4kJLO01Wr/wCDhHH/AHPO6Plz4p3Z/ZluGG80e0f/ADEX7hp5lUvaDtU6kdxrfe13gRHQcVmeWMTthwSyukW7q20HZewZ3kn6hR62z8e7PEtjgCW/JqqsD2wBAFQEHiII+chWVLtRRNvaN7zHzXL5hHploJr0IrOzFc1B7V4LdSHEnzGZV22o3DjdYwMGp17zqk09rMcLOB5gghKdjgRBgrTy7vUxDBsfKE1NsBwIDvA/uqDaGzMNVdvVGy6ReXDLIQDcdUe1sACC6md08slnTj3j3ZBIzXlnJ35j2RwYpq1+zXdkNmUsI0im9xLvilwMxYW0gcFrGVmkXHhZcoobUg3sZzyWlwG2CQL94yXeElXBwy6aujWVjFwZUI7QAMTBTeGxW+LlZH8Q9tNwjaT4Jc95bA4BpJPjCZIyq4HnSSdSNoMfzTgxq47R7f0rSSONjKscJ26pEGKmWc2+a47sq7RrbB+p1QYuVTbXwwg1G9Tw/wArIU/xCwwDd6oLmLXI5mMhzUfbW0qhqvBrTTMENBMRAcBGWfimXKtlyR00+FzyVFl5TxwMn6jL6pNbEsABLTfiIjxz7lS0a3uxmTcGwgzwjLl5qTQrA3NxwJ4r5MtXL2R96GgS5tlhiMM1wsGmRY6+IUTDbaq4eBUl1OTDsy3kTomJaSfdaeAdI8DMeKXXqua07g3/AOamXb7SNSIj6rtjzQk+VT+hmePJjVfyXsy8p7ap1/dNxo7UJqRoZXN9qbWGGrNIZuscJ9w7zdJgHKDotfsHb+ErWpkl5EbsQQQJl3Ac19DDPNCSXaZ87VR0uSDa8skbHYW1PZnccfcJ/wCk8ei1UZLnrStHsDaU/wAJxM/pPLh1X0pI+GmX504oAzw5Gc0DOiKJPSywaFb0dEQJRB3XrmgHT69QUAsG6JJLzz9dyCAigcInhx4pwOTUWvEfvzRkqA4tjqBp1alMiC1xjpvH14JiFsvxH2aAWYluvuv6gfYeLVjAV0i7Rlh7q2vZHY4pkVqkb36B/LIzPP5LFEpnD9rsRhSGOAq0hlNnAaCdY5hTI2lwWNXydqGMHkjGNELg+F7fYllUvefaMObLAD+m1umq0LfxRoRenVB4Q239y8rUjsmjrH5wc0puO0zXNdn/AIi4V+bzTPB4I8xI81bN7WYc2FZhOfxDLxWW5I0qN23FcVG2jhKVVu7UYHDn9DmFjR20w4e2n7Vu86YGcxzFloMFjfaNDmEFp8LZ96qn6Mqj6xMrtvsxh6ZJ3S0cQ5wKzGL7PiSaVZ3R0OHjYrp+1MIyq3cqDeYbEAwYP7qmp9lMOxoa1tYNmb1S4+c6aLi9qbo9sFmaVv8AZzZ2IqUHbpJY7TddLXdPsVLw/aau03dvDmPstdjexuFqtLHe2BJsQ4EjnDgVXYz8M4ANLFF0fEHNAcehBieoSOyXR6fEyQ4mrI2H7Yb3uvbHS6o+1WLke1pP3Xai1x0+q1DcDgMOwipTD3D4iSXPB6TZVWLxmBlhbhWneOZsQBJ1nwXrjppv6nz8muxO1VGGZ2nqgEHdJ4/sr7YnbFotU9w+IP2K0uz9q4TeLBTa3d1LWnrfkrN2HwmIAPs8PUbMH3W7zT1A5Kyw7e1RjFlcnUZ39C27JYo4imXMda0G4Dp4HWI0VR297D43GOpGn7MtYHCHPgy4i+UZAarQ4Zu7BY8BoaGhkQABkBwT9Xbxo/8AiA7p1Fx8145ZZQvcuDq8W/ow1D8FHloL8W1rtQKZIHQ7wlPv/BARbG350v8A9raYbtRQf+uPFWDMc39Lwe9WOqjLpnKWnce0cX7RfhXjMM3fZGIbr7MHeHVtyRzErGHEVGVILnBzPduTbdyEHQL1UzFeOqoO03ZnC4xv8Wm0u0ePdcOjhfuyXbxIvs57JR64OI7P7U7pHtWk82xPeFoKfaTDwD7VsHQi4PSJUPbn4ZV6ZcaD2vYLgOkOA7hB8lg8XScx7mOEOaSDebheeWiw5Ha4+x7cfxTUY1T5+50ut2jwwAms030v4wq3aPbGm0j2Q33ARNw3zuVgN5ONcUh8OxRdu2XJ8XzzVKkb/spRpYv2ntmguaQQJMBpmwvlK2WztkUKXwU2tPEC6xf4agg1QWkBwaWug3gmYtpI8Vv2WX0saSjwfJnJydsfS6biCDkQmt5GHLZg2eyMeKrc4ePi581YfRYPC4lzHBzTcef7LZ4HFiqwOHflIPBYao2mSQ7klHgi3kn0O9ZKOb3JBJRoCC6oPVzdNtfN5J9ZHzRF6ZdVMgCNZ18FCiNrUG1aL6bsnDPQEXB7iuOvpljnMNi0x681119a3Dgufdt8KG1G1mxB918aED7D+3mrF0yPoo5UXF4YOF1ISmtkwBJOnFdWYMvidlmbCeCtdnfh1jq0EUgxp/VUcG2PK7vJdW7OYGnQptIaPaEDedrOsHQdFbf6qwGC6DzXklOKZ6YYm0cub+DmIi+Jog8N15Hjb5KO78HsZ/6uHI4y/wD+i66NoNmAZKRV2qwHM+EqeJH3NrC36HIML+FeLbWpiqGOo7w33U3zDRnY7rhMRIFpXVK1VrQ0NgBlgBYCBke6FJZtiiSBviTobIYrDtfceS55LnHyM74o+FLzoocTtQyTl/La/VSP9Yba8W19XRYzDObzCinEM1AnpdeBY8qbtn0XqMVLyllRxbSJcQT3omC53XwDaHerqv8AzFN3uwEs1YyMRpyW3CVc8kjqIN+1kTt12cZWb7amWsrjMzAqDgefAnkFyfG71BwZVa5pDiYcCCRoRxHMLrztvtAgtBJ0MXVLtDDe1bDQyoDnSeB/bNj5FeiGulBpHGfw6OVXdP8A34OY/nne9EXNzyUjD7aqsu126LSRrHzV7X2Dh3GzN06tu0jwiVT4zZ+GYYc4t4DeP1XvhrXNcM+Vl0DxPn8mn2N2+bliWQ3R7Rf/AJN+3gtlhMTRxFMmm9tRh4GY6jMHkVyrD7Dw72k+3Nri7YHXJVjcZ+Xqb1Cs4kfqbYfXeHIhYlUukbhlnDt2dOINNxaLdyksxcRNuBWSwfbSnVaG1xuPj4wPdceYvupravaOGu9mWPGjmukg/wC5pi3MSvA9Ncuj0T1Fq0bp+3atMhzSHCMtYVxsvtGytYe6eB4rhVPtLiAfecHciI8IVhsbtQQ/+LAECCAcxxzUnpZw80H/AESOeEuJL+zvFV0i2a4Z2s2XSwuIeytTc4v99jgfiBJkmCADvSrnF/iAadqRdUI1mG/c+Cw22dqVcTVNWq6XEADgGjIDl91203iN3JUjhn2Lp2NtrUZvSdE6P07wpNHaNJs7mHZOheXPjuNiqwMUzBYaSF7TznQewNRxY9zySXOmT6t0Wva5Z7s5R3KYAV60rqlSObHi5JFQowUZCoAHlT9k7SdSfObT8Q4j7qu3CkglRg6PRrBzQ4EFpy7+/wAk93LFbC2waR3HfAcv9pOvRbJhsubVG0xc8Uabc2bET0sgoUqHCTvSYIyy+d+5MF54R4FPVB3TwUY+uXkoUi1jznxy5qm21h/bUn05zFrRBzGki/kreu65F+vWfKyrK8wBBnlAz1+uqgOe0HGC02c2x9eXchWxTmDeYYc24PMXU3tHhPZVhUHwvznQ6/fxVfVpiF1i7Rh8MlbH/ERwMYhtv5maf8ft4LbvrsqtaQ4EOEtMi44jiuM7RwUEkZKvc58AbzoGQkwLzbhe68ksMX2emOaS6O0fkiHEsrEHpNvFOHD1g2G1GnqCPuuN0NrYhjg5tapIylxcPAyFbUO3GMbYua7q2/lCx8tA2tVM2uL2ZXDpAB1J3lP2VtqpTIZUnhJ3m/RYOh29xA3t9jHSIEEtj5yoWI7YYpxmWNsMhw6laji29G3q9/Ekdvo7Qa+28O+Vl+29KpQpvrMAIAk8DlqFitjdsQ1kVmu3hk5kQ7qND0Q7R9sH4mj7BrXCnaS4ibXiB91rb7mHkVeVlYztXVBB3cjPxHP7clb4b8QHZPp5D4gZJPSPqsh7BD2BWtq9jjvl7lptntC+uTDdwEzne2XQ9EvB9pajIDzvjj+ofdVIw5KWNnOOikscZqmjrjz5Mb3RkbultmjXpjfbvR+oQHjkTw5FRcVg6VQQyoHD+V9iOk59xWWw+y67TLLHrH+eitsNWri1SiTzbB8sx3W5Lh8q48xPow+IQmqyIrtqbIawE/CRofqMwqbdW9Jc6nDRBnJzZEa2Np5iCotHYbZuPsvTiU2vMfN1Tx77gZPD4RzzABVq7YjgMrrW4XBsZkFINMFdth5dxz52znTklf6Q/gt4MI3gnPYNTwxuOe/6Y/gnBs4hbp+FHBQcQ2k34nsB5kKbC7jKt2eeCuNlbOuDCedtLDt/UXf0tP1SD2lY34KRP9RA8gFUkg2bHACGgKxY5c4qdrq/6Qxv/GT5kqDiNuYh/wAVZ8cjuj+2ArvRmjq1XENYJe4NHFxAHmoFbtPhWZ1mn+mX/wDaCFyc1wTJMnxK2OwewlWuxlR9RtNrxMFpL40kWAnPNR5C7S1xPbqiPgpvf1ho+p8lV4jt1VPwUqbesu+y1eA/DLCg/wASpWqcRLWDyE+a1WzOxOzqfw4Vjj/7k1T/AHkwpuZdqOM1e0+LqndFUyf00wAT4XXoPs9Tc3C4drw7eFJgdMzvbg3pBvPVPYSixg3abGsHBoDRE2yCf7+inJRW/wAz3AhBA6ZnnCCApnic5EGLa6SmqpvA9ftfzUiqDoIOXHpKaqcpAB5X4hZKQMQ42gSCbzwn7fRQK4zBBidZzEWHq8q0qgGWzpfp/hQMRT5CIHzjhwnxQGb23hBVpvAF4kCNdD9FkMM8lvMWK6DjGxvfOD9sucrC7Vp+zrbw+CpJB5zfz+asHTJJcEavRlVWI2fwVwSkli6NWZTozNTAlMnCngtS7DhNnCBZ2F3GZ/LHglNwZ4LRjBhOtwoTYLKOhs6c1ObguStWUgl7q1tJZVNwPJLbs/krQNSgE2otkCls8BTqOFATdTG0m/E9o7x8lHft6iMiT0B+sK8IlstWsCOFnqvab+Wn4n7KLV7Q1Tlut7p+ZTeiUzWBB9ZrfiIHUgfNYh2Orv8A1vPISPkktwNV1909T+6z4iLtNdU2zQbnUB6SfkolXtNSHwtc7wA+/kqSlsd5zIHS6lU9itzJcekRz+Sy8hdo7V7Uv/TTaOpJ+yhVdvV3frjk0AKyo7Gbo0HiTfyUyngY+Fvhb9rLO9l2mZd7Z+ftHdSfqls2XUOYAnj+y1bMHrBiMo+2SkNwQygW8fJZ3FoytLYpObvAKZT2LTBG9Pec/ktQzARaL6SBPT6J9mB90SB5Z2ynJS2Wigp7HaCAGj/p+ullPpbKbmRPAW5K3w2AkSAQT0sJvfj45KwZhGjPLvvfPvVIVeB2QxrpDWg6wI9289Fp6RItBI6jvGXqVHZhJ3cotYjwtxz/AHVnSoXCqIP0n30IPfEcu/yVpSfkqyi2HTFzx5ZW+qn06eUWj1ktAm0XTl9/QsngdeHeowGkfsNdE854A0vlz6KgeLo0PddGkG8Gbcr/AEQQFe0fNR6usX+nJSXDqmnsE8PXBZKQiyMvXOP3UfENFxnoVOezOVEr0QSCQCRlxE/RAVdZsi2R5jy5LM9pcJ7RjhHvN94W1GYnpK1uJpG8a539QqnGUgZ46m2gJziwWWUwOHfvN5ixTzQmNuA4aoTuy11wJjPh0KqX7fd+ljR1JP2XZTVHNoviESzNXbFU/qDegH1UWrinn4nuPeU3oUax9djfic0dSEw/a1EfrnoCVmqFAu+ESpdPZLznZZ3l2li/b7P0scepA+6jVO0D9GNHWXfZGNixck89FLbshg/T3mVN7LtKqptWs79ZHJoA+kpotqvz3z1J+q0zMBF2gAdNE8zAO4melov3LO4tGXp7LqHQDv8AspFPY51d4D6+slp27Og8+R14p6lgb62zB6WJ5WiVLFFBT2GwXhx1vpwy6hSaGzGjJvlfrxV9R2eYymM9eg4qazACT0+9s+nipZaKBmCuQIn1wTzMARa2U85m+uSvqeCltgQOXgePgpTdn+9ECLXyMG+uYsMkBnG4IX4gag2n5p9mD0I1gxbO4zPPRaX8iLSIjPhP+FIpYYmbQR393h9EBnmbPnu6i6cZg/hGcRJBPWcuYz4rRflhLSbTkCBMkCZ4GOCfpYbP6jX63v3pRLKOjgQRIGseBAtqnHbN3b3dfUgXnPoJ8gr+jhjkR01vr0H3TjaGevO2foK0LKKngBIdum+ZgH6znHjlwlUME1wsZYeGvOfsrMMAzkyeU5xHinvy4bGmkDKEoWV2HwYaLAjPTPnGeikfl95uVj4xrn3qcKeo4BLGGvmcvWfXVWiEJmFaBBEXtaMjxCeDDJAaeMnpp8vmpbKUXvcZGE8xuR0+6oI9GnN4ImOE8TqQpDWTJt4zxg8s0ptLLWDxniJz5lHTYdSNMhceGioHaYNvO6daOWfNNsdeIOUynAe7191QE6Y48xZBLHq8fVBAV9jfKLA+uabr07nQm3Ge6U882Gg4f41SG5nPrw5LJojubOuRv14ftzUcshxtnrHjPloFLfSgZyePFNvHDp3hCFZjGHc/VNjAJk3uOii1aXd1AJv09fMWjgLSAT496h4hpkgA99xx9HkoUy3aLYzMQ1rXkiDYtgGeEEeoVTT7I4ZrZLC4xm5zs+kwts+kN3QeoChjDkDduYGfH7rJTOHYdJo92k3/AIhoKrKnZ2g873s7kxMyCeMTH+FsDQdoRHAiLDNIq4KS2wOc3yEG4EXv80BmKOyg2WtY0cI4Tw0TrsC0ETEn1bjkVpaeCJiwga3HK335JLNntBnn8OdzGXDie9AZ2psvKJn0YvbzCedgDF2iNZvIz0H2WldgouBIjK8kkzaNU+3DieFss4jjpN9UBnaGzZvFoyvEEeE2Uqls4Zjznorv2AAyNouYEk9fFSKWEM709RAPmlEso6ezeN+XAevmn6OAE/DHH3TeOZ6z8lcNwov7sT8XfnpBT1LD2MGRlnqLaZK0LKoYERcx61TzMIN69jHh481Ysw4bY3njnaB4Jz2I3puDlyNj91aJZW/koac5Fxu2PHImJnipLcMNZy5cr8tVMdRiIaSO7nxMp6lRznx+n7pRCvo4bS/KZkRz4ZJ2lSF7W4kRw1OfXkpvsAcxOvS0IqjN0RBdYkgC/Pvn5qgjilecm56J1lLLLzPTyT4p+7lytmL91k77MjIoCMKYk3z6IewMtg+6BcQM5EHpmpDQDE69/jFoTjKIAgZCAI8cskBGbSFyBfgRHd5TdOfl+Q6+CkFoyNxwhBo4nyjNAMCnw0+ic3bx36pwc7fdGwGfoqBv2IzgTl01PrkjDM/Lu4p1rACTlOaPkgEETxHilNDeV/OPrZKLtPUc0llOLTYZDlCAXOv728UGjlGncg42zgcQjcchx6eoVAk67uev00RJRdrE6evNBARGi7vWg+6bi/SY5QggoUI59w81Ha75oIKAiueQCRn+0ptrQbwL59Iy6ckEFAR3H+GTrunyTFCmAGAC26D4oIKFBSYDvAgRMRpCRUpgNMCJF4zMAnPuQQQvoOUhLL393W/kpFOk1xkgHKJ06cO5BBUyLa2J9aBPMYOCCCAID3iOAHnMqRuAAkC8FBBUgioLj+lHh3TM/wA0fJGggJYYL2ULEVC2lUcDcTHcTpkggqPQk4aoSyTnCfB91BBPUBgQ2dfFKflPT5oIIBVP4iOUoO0/q+hQQRgOuYbZKo3F/WiCCAbovJcWnKD81KARIIBNXLwR17CfWYQQVA48W6pOncggiAN2xSWH3UEEAYdBgZR/8oTgF0aCAJp97u+qCCCpT//Z",
       "GS" => "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSbaPc_bRoPxddkaXr-6qi82jjS7vdn-eJxlfjVYN_P9GLwg5nB" 
   }
   
   #랜덤으로 하나를 출력한다.
   @menu_result = menu.sample
   @menu_img = menu_img[@menu_result]
   
   #이름과 url을 넘겨서 erb를 랜더링한다.
   erb :lunchhash
end

get '/randomgame/:name' do
    @name = "#{params[:name]}"
    
    man_img = ["http://fimg4.pann.com/new/download.jsp?FileID=36895749","http://www.topstarnews.net/news/photo/201804/392424_37687_5028.jpg",
    "http://image.hankookilbo.com/i.aspx?Guid=d89aed14f5e84df883e02b0d3238ec8d&Month=HKSports&size=640","http://img.insight.co.kr/upload/2015/06/16/ART150616064913.jpg",
    "https://dispatch.cdnser.be/wp-content/uploads/2016/12/1e9f09cab883899da6e3cab28ba76ef5.jpg"]

    
    @man_img = man_img.sample
    
    erb :randomgame
 
end



get '/lotto-sample' do
    #랜덤하게 로또번호 추첨!
    @lotto = (1..45).to_a.sample(6).sort
    
    #erb파일 랜더링
    url ="http://www.nlotto.co.kr/common.do?method=getLottoNumber&drwNo=809"
    @lotto_info = RestClient.get(url) #JSON
    @lotto_hash = JSON.parse(@lotto_info)

    @winner = []
    @lotto_hash.each do |k,v|
        if k.include?('drwtNo')
            #배열에 저장
           @winner << v 
        end
    
    end
    
    #winner와 lotto를 비교해서 몇 개가 일치하는 지 연산
    @matchnum = (@winner & @lotto).length
    @bonusnum = @lotto_hash["bnusNo"]

    #몇 등인지를 출력 (if)
    
    # if(@matchnum == 6) then @rank = "1등"
    # elsif (@matchnum == 5 && @lotto.include?(@bonusnum))
    #     @rank = "2등"
    # elsif (@matchnum == 5) then @rank = "3등"
    # elsif (@matchnum == 4)
    #     @rank = "4등"
    # elsif (@matchnum == 3)
    #     @rank = "5등"
    # else
    #     @rank = "5등 밑이야~~"
    # end
    
    
    #몇 등인지를 출력 (case)
    
    
    # case [@matchnum, @lotto.include?(@bonusnum)]
    # when [6, false] then @rank = "1등"
    
    @rank = 
    case [@matchnum, @lotto.include?(@bonusnum)]
    when [6, false] then "1등"
    when [5, false] then "2등"
    when [5, true] then "3등"
    when [4, false] then "4등"
    when [3, false] then "5등"
    else"꽈아앙"
end

    erb :lottosample
    
end

get '/form' do
    
    erb :form
end

get '/search' do
    @keyword = params[:keyword]
    url = 'https://search.naver.com/search.naver?query='
    #erb :search
    redirect to (url+@keyword)
end

get '/opgg' do
    erb :opgg    
end

get '/opggresult'do
    url ='http://www.op.gg/summoner/userName='
    @userName = params[:userName]
    @encodeName = URI.encode(@userName)
    
    @res = HTTParty.get(url + @encodeName)
    @doc = Nokogiri::HTML(@res.body)
    
    @win = @doc.css("#SummonerLayoutContent > div.tabItem.Content.SummonerLayoutContent.summonerLayout-summary > div.SideContent > div.TierBox.Box > div.SummonerRatingMedium > div.TierRankInfo > div.TierInfo > span.WinLose > span.wins").text
    @lose = @doc.css("#SummonerLayoutContent > div.tabItem.Content.SummonerLayoutContent.summonerLayout-summary > div.SideContent > div.TierBox.Box > div.SummonerRatingMedium > div.TierRankInfo > div.TierInfo > span.WinLose > span.losses").text
    @rank = @doc.css("#SummonerLayoutContent > div.tabItem.Content.SummonerLayoutContent.summonerLayout-summary > div.SideContent > div.TierBox.Box > div.SummonerRatingMedium > div.TierRankInfo > div.TierRank > span").text
    
    #File.open(파일이름, 옵션)
    
    # File.open('opgg.txt','a+')do |f|
    #     f.write("#{@userName} : #{@win}, #{@lose}, #{@rank}\n")
    # end
    
    CSV.open('opgg.csv','a+') do |c|
        c << [@userName, @win, @lose, @rank]
    end
    erb :opggresult
    
end

get '/oplog' do
    @log = []
    CSV.foreach('opgg.csv') do |row|
        @log << row
    end
    erb :oplog
end

