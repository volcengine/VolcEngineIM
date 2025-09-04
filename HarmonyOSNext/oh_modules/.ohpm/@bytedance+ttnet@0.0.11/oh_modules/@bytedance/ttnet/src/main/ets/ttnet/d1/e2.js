export class TobAppConstants { } TobAppConstants.APP_ID = 1234567890; TobAppConstants.APP_NAME = "ttnet"; TobAppConstants.APP_STRING_NAME = "TTNet网络库"; TobAppConstants.CHANNEL_NAME = "local_test"; TobAppConstants.VERSION_CODE = "797"; TobAppConstants.VERSION_NAME = "7.9.7"; TobAppConstants.MANIFEST_VERSION_CODE = "7965"; TobAppConstants.UPDATE_VERSION_CODE = "79708"; TobAppConstants.DOMAIN_HTTPDNS_KEY = "httpdns"; TobAppConstants.DOMAIN_BOE_KEY = "boe"; TobAppConstants.tncFirstHost = "unavailable.test.com"; TobAppConstants.tncSecondHost = "unavailable2.test.com"; TobAppConstants.tncThirdHost = "unavailable3.test.com"; TobAppConstants.enableOpaque = false; TobAppConstants.getDomainDefaultJson = `{
    "data":
    {
        "chromium_open": 1,
        "ttnet_http_dns_enabled": 0,
        "opaque_data_enabled": 1,
        "ttnet_quic_enabled": 1,
        "ttnet_local_dns_time_out": 2,
        "ttnet_h2_enabled": 1,
        "ttnet_url_dispatcher_enabled": 1,
        "tnc_update_interval": 18000,
        "ttnet_nqe_watching_groups":
        [
            "api.hypstar.com",
            "*",
            "www.baidu.com"
        ],
        "ttnet_socket_pool_param":
        {
            "max_sockets_per_group": 20
        },
        "ttnet_quic_internal_param":
        {
            "congestion_control_type": 4,
            "defer_send_in_response_to_packets": 1,
            "enable_retry_connect_other_dns_ip": 1,
            "icwnd_size": 50
        },
        "ttnet_buffer_config":
        {
            "ttnet_request_body_buffer_size": 1048576
        },
        "ttnet_socket_config":
        {
            "enable_quick_test_when_socket_timeout_set": 0,
            "triplicate_ip_numbers_less_than": 0
        },
        "ttnet_dispatch_actions_epoch": 1907849
    },
    "message": "success"
}`; 