#
# Time Tracking Report
#
# Generate a time tracking report from a plain text time tracking table.
#
#
# EXAMPLE
#
#     given a file 'time-tracking.txt':
#
#         ===== 2021 ==========================================================
#
#         ----- KW 52 ----------------------------------------------------------
#
#         FR:
#             4h did this
#             3.5h did something else
#             0.5h etc.
#
#         DO:
#             8h foo
#
#    generate this:
#
#        Fri, 31.12.2021: 8 hours
#        Thu, 30.12.2021: 8 hours
#
#
#
# USAGE
#
#     awk -f timekeeping.awk time-tracking.txt
#

/===== [0-9]{4} =====/ {
  year = $2
}

/----- KW [0-9]+ -----/ {
  kw = $3
}

#/^(MO|mo):/ {
  #weekday = 1
  #sum = 0
#}

/^(DI|di):/ {
  weekday = 2
  sum = 0
}

/^(MI|mi):/ {
  weekday = 3
  sum = 0
}

/^(DO|do):/ {
  weekday = 4
  sum = 0
}

/^(FR|fr):/ {
  weekday = 5
  sum = 0
}

/^(\t| +|- +)[0-9\.]+h? / {
  gsub("^- +", "", $0)
  gsub("^ +", "", $0)
  gsub("^\t", "", $0)
  gsub("h$", "", $1)
  sum += $1
}

/^$/ {
  if (sum > 0 && weekday > 0) {
    system("echo $(date -j -f '%Y %U %u' '"year " " kw " " weekday"' '+%a, %d.%m.%Y'): " sum " hours")
    sum = 0
    weekday = 0
  }
}

