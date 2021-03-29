
terraform {
  backend "gcs" {
    bucket      = "savvy-folio-308301-cian-website-tfstate"
    prefix      = "portfolio"
    credentials = "account.json"
  }
}

