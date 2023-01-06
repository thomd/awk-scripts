#
# Flatten a Saleforce Permission Set XML to make them sortable
#
#
# USAGE
#
#      awk -f Flatten-salesforce-permission-set.awk my-permission-set.xml | sort
#
#      icdiff <(awk -f flatten-salesforce-permission-set.awk 1.xml | sort) <(awk -f flatten-salesforce-permission-set.awk 2.xml | sort)

BEGIN {
  node = 0
}

/<label>/ || /<license>/ || /<hasActivationRequired>/ {
  gsub(/^ */, "", $0)
  print $0
  next
}

/<fieldPermissions>/ || /<objectPermissions>/ || /<userPermissions>/ {
  node = 1
}

/<\/fieldPermissions>/ || /<\/objectPermissions>/ || /<\/userPermissions>/ {
  node = 0
  gsub(/^ */, "", $0)
  print $0
}

{
  if (node == 1) {
    gsub(/^ */, "", $0)
    printf("%s", $0)
  }
}

/<?xml / || /<PermissionSet / || /<\/PermissionSet/ {
  #print $0
}


