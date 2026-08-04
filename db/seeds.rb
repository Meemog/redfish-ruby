# Roles
admin_role = Role.find_or_create_by!(name: "admin")
user_role  = Role.find_or_create_by!(name: "user")


# Permissions
permissions = [
  "assets.read",
  "assets.write",

  "paths.read",
  "paths.write",

  "history.read",
  "history.write",

  "racks.read",
  "racks.write",

  "templates.read",
  "templates.write",

  "template_paths.read",
  "template_paths.write",

  "users.write"
]

permissions.each do |name|
  Permission.find_or_create_by!(name: name)
end


# Admin gets everything
admin_role.permissions = Permission.all


# User only gets read permissions
user_role.permissions = Permission.where(
  name: [
    "assets.read",
    "paths.read",
    "history.read",
    "racks.read",
    "templates.read",
    "template_paths.read"
  ]
)

# Create test users
User.find_or_create_by!(username: "admin") do |user|
  user.passwordHash = Digest::SHA256.hexdigest("otter")
  user.role = admin_role
end

User.find_or_create_by!(username: "user") do |user|
  user.passwordHash = Digest::SHA256.hexdigest("password")
  user.role = user_role
end
