# JWT JWT JWT

[Lee Johnson](http://leejo.github.io)

YAPC::EU 2015

---
![me](img/card.jpg)

[leejo.github.io/code](https://leejo.github.io/code)

---

![villars](img/villars.jpg)

Villars-sur-Ollon

---

![franschhoek](img/franschhoek.jpg)

franschhoek

---

![seven oaks](img/oak.jpg)
![seven oaks](img/oak.jpg)
![seven oaks](img/oak.jpg)
![seven oaks](img/oak.jpg)
![seven oaks](img/oak.jpg)
![seven oaks](img/oak.jpg)
![seven oaks](img/oak.jpg)

(Seven Oaks)

---
## What is a JWT?



---
## What is a JWT?

eyJhbGciOiJIUzI1NiJ9.eyJtZXNzYWdlIjoiSGVsbG8gWUFQQyJ9.97WnnEhTjhdQ-ymuE5KIXs1TlqQKLsWk_lNJ7leaziQ

---
## What is a JWT?

Header

[eyJhbGciOiJIUzI1NiJ9]().eyJtZXNzYWdlIjoiSGVsbG8gWUFQQyJ9.97WnnEhTjhdQ-ymuE5KIXs1TlqQKLsWk_lNJ7leaziQ

---
## What is a JWT?

Claims

eyJhbGciOiJIUzI1NiJ9.[eyJtZXNzYWdlIjoiSGVsbG8gWUFQQyJ9]().97WnnEhTjhdQ-ymuE5KIXs1TlqQKLsWk_lNJ7leaziQ

---
## What is a JWT?

Signature

eyJhbGciOiJIUzI1NiJ9.eyJtZXNzYWdlIjoiSGVsbG8gWUFQQyJ9.[97WnnEhTjhdQ-ymuE5KIXs1TlqQKLsWk_lNJ7leaziQ]()

---
## What is a JWT?

Header
```
{
	"alg": "HS256"
}
```

Claims (note [registered claim names](https://tools.ietf.org/html/rfc7519#section-4.1))
```
{
	"message": "Hello YAPC"
}
```

Signature
```
encode_base64url(
	hmac_sha256(
		join( '.',
			encode_base64url( $header ),
			encode_base64url( $payload ),
		),
		$secret,
	)
);
```

---
## Why use a JWT?



---
## Why use a JWT?

Stateless backend:

```
{
	"user_id": 12345,
	"expires": 1439814659,
	"scopes": [
		"user:email",
		"user:follow",
		"repo:status",
	]
}
```

---
## Stateless? But...

Revoking tokens?

---
## Stateless? But...

Revoking tokens?

  - Use a short TTL?
  - have a jti in the claims, store in memcached to revoke?

---
## How to encode/decode a JWT?

- [Mojo::JWT](https://metacpan.org/pod/Mojo::JWT)
- [JSON::WebToken](https://metacpan.org/pod/JSON::WebToken)
- [Crypt::JWT](https://metacpan.org/pod/Crypt::JWT)

- [Acme::JWT](https://metacpan.org/pod/Acme::JWT)
    - Acme?
    - Unmaintained?
- [Mojar::Auth::Jwt](https://metacpan.org/pod/Mojar::Auth::JWT)
    - Unmaintained?
    - ->decode doesn't check signature by default

---
## More information

[RFC 7519](https://tools.ietf.org/html/rfc7519)

[jwt.io](http://jwt.io/)

---
## Thank you
