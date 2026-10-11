package com.harness.demo;

import java.util.Map;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
public class InfoController {

    @Value("${app.build.version:dev}")
    private String buildVersion;

    @Value("${app.environment:local}")
    private String environment;

    @GetMapping("/version")
    public Map<String, String> version() {
        return Map.of(
                "service", "product-catalog",
                "version", buildVersion,
                "environment", environment
        );
    }
}
