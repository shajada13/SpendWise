package com.spendwise.util;

import org.springframework.web.multipart.MultipartFile;

import java.util.Arrays;
import java.util.UUID;

/**
 * File upload utility methods
 */
public final class FileUtil {

    private FileUtil() {}

    private static final String[] ALLOWED_TYPES = {
            "image/jpeg", "image/png", "image/gif", "image/webp"
    };

    public static String generateFileName(String originalName) {
        String extension = getExtension(originalName);
        return UUID.randomUUID() + "." + extension;
    }

    public static String getExtension(String fileName) {
        if (fileName == null || !fileName.contains(".")) return "";
        return fileName.substring(fileName.lastIndexOf(".") + 1).toLowerCase();
    }

    public static boolean isValidImageType(MultipartFile file) {
        if (file == null || file.isEmpty()) return false;
        String contentType = file.getContentType();
        return contentType != null &&
                Arrays.asList(ALLOWED_TYPES).contains(contentType);
    }

    public static boolean isValidSize(MultipartFile file, long maxSizeBytes) {
        return file != null && file.getSize() <= maxSizeBytes;
    }
}
