variable "source_file" {
  type = string
  description = "アップロードするpngファイルのパス"
}

variable "output_path" {
  type = string
  description = "アップロード先のパス"
}

variable "s3_bucket_id" {
  type = string
  description = "アップロード先のS3バケットID"
}

variable "s3_object_key" {
  type = string
  description = "アップロード先のS3オブジェクトキー"
}

variable "function_name" {
  type = string
  description = "Lambda関数名"
}

variable "handler" {
  type = string
  description = "Lambda関数のハンドラ名"
}

variable "lambda_variables" {
  type = map(any)
  description = "Lambda関数の環境変数"
}

variable "lambda_iam_arn" {
  type = string
  description = "Lambda関数のIAMロールARN"
}

variable "layers" {
  type = list(string)
}