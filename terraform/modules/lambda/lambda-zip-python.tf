###################
# Python
###################
#Before using this module, prepare py code and requirement.txt in the same folder
resource "null_resource" "install_python_dependencies" {
  count = var.lambda_zip_python != null ? 1 : 0

  provisioner "local-exec" {
    command = <<EOT
      ROOT_PATH=$(pwd);
      echo "ROOT_PATH: $ROOT_PATH";
      CODE_PATH=${var.lambda_zip_python.code_path};
      echo "CODE_PATH: $CODE_PATH";
      cd ${var.lambda_zip_python.code_path};
      mkdir -p .packages${length(var.lambda_function.layers) > 0 ? "/python" : ""};
      rsync -avr --exclude='*.git*' --exclude='*.zip' --exclude='requirements.txt' --exclude='*.packages' . .packages${length(var.lambda_function.layers) > 0 ? "/python" : ""};
      set -e && pip3 install -r requirements.txt -t .packages${length(var.lambda_function.layers) > 0 ? "/python" : ""} --upgrade;
      cd .packages;
      set -e && zip -r ${var.lambda_zip_python.code_zip_name}.zip * -x '*.git*' -x '*.zip' -x 'requirements.txt' -x '*.packages';
      cd ..;
      CODE_ZIP_PATH=${var.lambda_zip_python.code_zip_path};
      echo "CODE_ZIP_PATH: $CODE_ZIP_PATH";
      cp .packages/${var.lambda_zip_python.code_zip_name}.zip $ROOT_PATH/${var.lambda_zip_python.code_zip_path};
      rm -rf .packages
   EOT
  }
  triggers = {
    file_hashes = jsonencode({
      for file in fileset("${var.lambda_zip_python.code_path}/", "**") :
      file => filesha256("${var.lambda_zip_python.code_path}/${file}")
      if file != "${var.lambda_zip_python.code_zip_name}.zip"
    })
  }
}

locals {
  install_python_dependencies_id = var.lambda_zip_python != null ? null_resource.install_python_dependencies[0].id : null
  lambda_filename                = local.install_python_dependencies_id != null ? "${var.lambda_zip_python.code_zip_path}/${var.lambda_zip_python.code_zip_name}.zip" : var.lambda_function.filename
  lambda_handler                 = var.lambda_zip_python != null ? "${var.lambda_zip_python.code_zip_name}.lambda_handler" : var.lambda_function.handler
}
