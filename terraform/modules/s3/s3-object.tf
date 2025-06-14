data "template_file" "s3_object" {
  for_each = {
    for value in var.s3_objects : value.key
    => value if value.content != null
  }

  template = file(each.value.content.template)
  vars     = each.value.content.vars
}

resource "aws_s3_object" "s3_object" {
  for_each = { for value in var.s3_objects : value.key => value }

  bucket       = aws_s3_bucket.s3_bucket.id
  key          = each.value.key
  content      = each.value.content != null ? data.template_file.s3_object[each.key].rendered : null
  source       = each.value.source
  acl          = each.value.acl
  content_type = lookup(local.content_type, regex("\\.[^.]+$", each.value.key), null)
  etag         = each.value.content != null ? md5(data.template_file.s3_object[each.key].rendered) : each.value.source != null ? filemd5(each.value.source) : null
}

locals {
  content_type = { #https://developer.mozilla.org/en-US/docs/Web/HTTP/Basics_of_HTTP/MIME_types/Common_types
    ".aac"    = "audio/aac",
    ".abw"    = "application/x-abiword",
    ".arc"    = "application/x-freearc",
    ".avi"    = "video/x-msvideo",
    ".azw"    = "application/vnd.amazon.ebook",
    ".bin"    = "application/octet-stream",
    ".bmp"    = "image/bmp",
    ".bz"     = "application/x-bzip",
    ".bz2"    = "application/x-bzip2",
    ".cda"    = "application/x-cdf",
    ".csh"    = "application/x-csh",
    ".css"    = "text/css",
    ".csv"    = "text/csv",
    ".doc"    = "application/msword",
    ".docx"   = "application/vnd.openxmlformats-officedocument.wordprocessingml.document",
    ".eot"    = "application/vnd.ms-fontobject",
    ".epub"   = "application/epub+zip",
    ".gz"     = "application/gzip",
    ".gif"    = "image/gif",
    ".html"   = "text/html",
    ".htm"    = "text/html",
    ".ico"    = "image/vnd.microsoft.icon",
    ".ics"    = "text/calendar",
    ".jar"    = "application/java-archive",
    ".jpg"    = "image/jpeg",
    ".jpeg"   = "image/jpeg",
    ".js"     = "text/javascript",
    ".json"   = "application/json",
    ".jsonld" = "application/ld+json",
    ".mjs"    = "text/javascript",
    ".mp3"    = "audio/mpeg",
    ".mp4"    = "video/mp4",
    ".mpeg"   = "video/mpeg",
    ".mpkg"   = "application/vnd.apple.installer+xml",
    ".odp"    = "application/vnd.oasis.opendocument.presentation",
    ".ods"    = "application/vnd.oasis.opendocument.spreadsheet",
    ".odt"    = "application/vnd.oasis.opendocument.text",
    ".oga"    = "audio/ogg",
    ".ogv"    = "video/ogg",
    ".ogx"    = "application/ogg",
    ".opus"   = "audio/opus",
    ".otf"    = "font/otf",
    ".png"    = "image/png",
    ".pdf"    = "application/pdf",
    ".php"    = "application/x-httpd-php",
    ".ppt"    = "application/vnd.ms-powerpoint",
    ".pptx"   = "application/vnd.openxmlformats-officedocument.presentationml.presentation",
    ".rar"    = "application/vnd.rar",
    ".rtf"    = "application/rtf",
    ".sh"     = "application/x-sh",
    ".svg"    = "image/svg+xml",
    ".swf"    = "application/x-shockwave-flash",
    ".tar"    = "application/x-tar",
    ".tif"    = "image/tiff",
    ".tiff"   = "image/tiff",
    ".ts"     = "video/mp2t",
    ".ttf"    = "font/ttf",
    ".txt"    = "text/plain",
    ".vsd"    = "application/vnd.visio",
    ".wav"    = "audio/wav",
    ".weba"   = "audio/webm",
    ".webm"   = "video/webm",
    ".webp"   = "image/webp",
    ".woff"   = "font/woff",
    ".woff2"  = "font/woff2",
    ".xhtml"  = "application/xhtml+xml",
    ".xls"    = "application/vnd.ms-excel",
    ".xlsx"   = "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet",
    ".xul"    = "application/vnd.mozilla.xul+xml",
    ".zip"    = "application/zip",
    ".7z"     = "application/x-7z-compressed"
  }
}
