resource "aws_wafv2_ip_set" "wafv2_ip_set" {
  for_each = {
    for value in var.wafv2_web_acl_rules : value.name => value
    if lookup(value, "ip_set_reference_statement", {}) != {}
  }

  name               = "${var.project}-${var.env}-${each.value.name}-wafv2-ipset"
  description        = "${var.project}-${var.env}-${each.value.name}-wafv2-ipset IPs"
  scope              = var.wafv2_scope
  ip_address_version = "IPV4"
  addresses          = each.value.ip_set_reference_statement.addresses

  tags = {
    Name = "${var.project}-${var.env}-${each.value.name}-wafv2-ipset"
  }
}
