-- Cargar la librería OpenID Connect
local oidc = require("resty.openidc")

-- 1. Definir las opciones de validación
-- Esto traduce DIRECTAMENTE tu política APIM
local opts = {
	-- Usar la URL de descubrimiento de OpenID de Google
	discovery = "https://accounts.google.com/.well-known/openid-configuration",

	-- El 'aud' (Audience) que APIM estaba validando
	client_id = "283774374518-bajhpdes0tmuhstkmfblel3f1gfl4pft.apps.googleusercontent.com",

	-- Dónde cachear las claves públicas (JWKS) de Google
	-- (Debe coincidir con la 'lua_shared_dict' en nginx.conf)
	jwks_cache_dict = "openidc_jwks_cache",
	jwks_cache_key = "google", -- Clave única para las JWKS de Google

	-- Verificar el 'issuer' (como en APIM)
	check_iss = true,

	-- No necesitamos un 'client_secret' para validación de tokens
	-- Aceptar tokens del header "Authorization: Bearer <token>"
	token_header = "Authorization",
}

-- 2. Ejecutar la validación
-- 'oidc.jwt_verify_header' hace todo:
--   - Extrae el token
--   - Valida la firma contra las JWKS cacheadas
--   - Valida 'exp', 'iss', 'aud'
local jwt, err = oidc.jwt_verify_header(opts)

if err then
	ngx.log(ngx.ERR, "Error de validación de JWT: ", err)
	ngx.status = 401
	ngx.header["Content-Type"] = "application/json"
	ngx.say('{"error": "Unauthorized. Invalid or expired token."}')
	return ngx.exit(ngx.HTTP_UNAUTHORIZED)
end

-- 3. Inyectar los Headers
-- Si la validación es exitosa, 'jwt' contiene el payload
ngx.req.set_header("X-User-ID", jwt.sub)
ngx.req.set_header("X-User-Name", jwt.name)
ngx.req.set_header("X-User-Email", jwt.email)
ngx.req.set_header("X-User-Avatar", jwt.picture)

-- Continuar con la solicitud
return
