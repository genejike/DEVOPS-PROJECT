module "users" {
    source = "../../../modules/landing-zone/iam-user"
    iam_user_tag = "iam_creation_tag"
    user_names = [ "cy", "noe", "emma" ]
    
}
