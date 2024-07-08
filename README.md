
# Sliding Window Rate Limiting with NGINX and JavaScript (njs)

## High-Level Design (HLD)

### Components
1. **NGINX**: The web server and reverse proxy handling incoming requests.
2. **JavaScript (njs)**: Implementing the sliding window rate limiting logic.
3. **Redis**: Storing rate limiting states (request counts and timestamps).

### Workflow
1. **Client Request**: Incoming request to NGINX.
2. **JavaScript Execution**: njs script checks Redis for the rate limit state.
3. **Rate Limiting Check**: Sliding window algorithm processes request counts and timestamps.
4. **Redis Update**: Update the request count and timestamps in Redis.
5. **Decision**: Allow or block the request based on the rate limit.

## To-Do List

### Step 1: Install Required Software
- Install NGINX with njs module.
- Install Redis for storing rate limit states.
- Ensure Node.js is installed if you plan to use additional Node.js modules.

#### Installation Commands

```bash
# Install NGINX with njs module
sudo apt-get update
sudo apt-get install nginx-module-njs

# Install Redis
sudo apt-get install redis-server

# Ensure Redis is running
sudo systemctl start redis
sudo systemctl enable redis

# Ensure Node.js is installed if needed
sudo apt-get install nodejs
sudo apt-get install npm
```

### Step 2: Set Up Redis
- Install and configure Redis server.
- Ensure Redis is running and accessible from the NGINX server.

#### Verify Redis Installation

```bash
redis-cli ping
# Should return PONG
```

### Step 3: Write JavaScript (njs) Script for Rate Limiting
- Create a directory for JavaScript scripts (e.g., `/etc/nginx/js/`).
- Write the JavaScript script implementing the sliding window rate limiting algorithm.

#### Create and Write the Script

```bash
sudo mkdir -p /etc/nginx/js/
sudo nano /etc/nginx/js/rate_limit.js
```

### Step 4: Configure NGINX to Use JavaScript (njs)
- Update NGINX configuration to load and use the JavaScript script.

#### Example NGINX Configuration (`/etc/nginx/nginx.conf`):

```nginx
http {
    js_import rate_limit from /etc/nginx/js/rate_limit.js;

    server {
        location / {
            js_content rate_limit.rate_limit;

            proxy_pass http://backend;
        }
    }
}
```

### Step 5: Reload NGINX and Test
- Reload NGINX configuration.
- Test the rate limiting and ensure it works as expected.
- Monitor logs for any errors and debug as necessary.

#### Reload NGINX

```bash
sudo nginx -s reload
```

### Testing
- Send multiple requests to the NGINX server and check if rate limiting is applied correctly.
- Monitor NGINX and Redis logs for any errors or issues.

## Conclusion
By following this guide, you can set up a sliding window rate limiting algorithm for NGINX using JavaScript (njs) and Redis. This modular approach keeps your configuration organized and allows for flexible and scalable rate limiting.

# Sliding Window Rate Limiting with NGINX and JavaScript (njs)

## High-Level Design (HLD)

### Components
1. **NGINX**: The web server and reverse proxy handling incoming requests.
2. **JavaScript (njs)**: Implementing the sliding window rate limiting logic.
3. **Redis**: Storing rate limiting states (request counts and timestamps).

### Workflow
1. **Client Request**: Incoming request to NGINX.
2. **JavaScript Execution**: njs script checks Redis for the rate limit state.
3. **Rate Limiting Check**: Sliding window algorithm processes request counts and timestamps.
4. **Redis Update**: Update the request count and timestamps in Redis.
5. **Decision**: Allow or block the request based on the rate limit.

## To-Do List

### Step 1: Install Required Software
- Install NGINX with njs module.
- Install Redis for storing rate limit states.
- Ensure Node.js is installed if you plan to use additional Node.js modules.

#### Installation Commands

```bash
# Install NGINX with njs module
sudo apt-get update
sudo apt-get install nginx-module-njs

# Install Redis
sudo apt-get install redis-server

# Ensure Redis is running
sudo systemctl start redis
sudo systemctl enable redis

# Ensure Node.js is installed if needed
sudo apt-get install nodejs
sudo apt-get install npm
```

### Step 2: Set Up Redis
- Install and configure Redis server.
- Ensure Redis is running and accessible from the NGINX server.

#### Verify Redis Installation

```bash
redis-cli ping
# Should return PONG
```

### Step 3: Write JavaScript (njs) Script for Rate Limiting
- Create a directory for JavaScript scripts (e.g., `/etc/nginx/js/`).
- Write the JavaScript script implementing the sliding window rate limiting algorithm.

#### Create and Write the Script

```bash
sudo mkdir -p /etc/nginx/js/
sudo nano /etc/nginx/js/rate_limit.js
```

### Step 4: Configure NGINX to Use JavaScript (njs)
- Update NGINX configuration to load and use the JavaScript script.

#### Example NGINX Configuration (`/etc/nginx/nginx.conf`):

```nginx
http {
    js_import rate_limit from /etc/nginx/js/rate_limit.js;

    server {
        location / {
            js_content rate_limit.rate_limit;

            proxy_pass http://backend;
        }
    }
}
```

### Step 5: Reload NGINX and Test
- Reload NGINX configuration.
- Test the rate limiting and ensure it works as expected.
- Monitor logs for any errors and debug as necessary.

#### Reload NGINX

```bash
sudo nginx -s reload
```

### Testing
- Send multiple requests to the NGINX server and check if rate limiting is applied correctly.
- Monitor NGINX and Redis logs for any errors or issues.

## Conclusion
By following this guide, you can set up a sliding window rate limiting algorithm for NGINX using JavaScript (njs) and Redis. This modular approach keeps your configuration organized and allows for flexible and scalable rate limiting.
