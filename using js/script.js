//Example JavaScript Script (/etc/nginx/js/rate_limit.js):
function rate_limit(r) {
    var redis = require('redis');
    var client = redis.createClient();
    var client_ip = r.remoteAddress;
    var limit_key = "limit:" + client_ip;
    var window_size = 60; // window size in seconds
    var max_requests = 10; // max requests per window

    client.on('error', function(err) {
        r.return(500, "Redis connection error: " + err);
    });

    client.get(limit_key, function(err, res) {
        if (err) {
            r.return(500, "Redis get error: " + err);
            return;
        }

        var data = res ? JSON.parse(res) : { count: 0, timestamps: [] };
        var current_time = Date.now() / 1000;
        var timestamps = data.timestamps || [];
        var count = data.count || 0;

        // Remove timestamps that are outside the window
        while (timestamps.length > 0 && current_time - timestamps[0] >= window_size) {
            timestamps.shift();
            count -= 1;
        }

        // Check if the request is within the limit
        if (count >= max_requests) {
            r.return(429, "Too Many Requests");
            return;
        }

        // Add the current timestamp and increment the count
        timestamps.push(current_time);
        count += 1;

        // Save the updated count and timestamps to Redis
        var new_data = JSON.stringify({ count: count, timestamps: timestamps });
        client.set(limit_key, new_data, 'EX', window_size, function(err) {
            if (err) {
                r.return(500, "Redis set error: " + err);
                return;
            }

            r.return(200, "Request allowed");
        });

        client.quit();
    });
}

export default { rate_limit };
