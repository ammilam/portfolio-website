
terraform {
  backend "gcs" {
    bucket      = "savvy-folio-308301-portfolio-website-tfstate"
    prefix      = "portfolio"
    credentials = "account.json"
  }
}

