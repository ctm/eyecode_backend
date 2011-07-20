class ActiveSupport::TimeZone

  # Remove the misleading <tt>(GMT </tt><i>offset</i><tt>)</tt>, since
  # it shows the wrong offsets in the United States when Daylight
  # Saving Time is being observed.  E.g., without this fix, we get
  # <tt>(GMT-07:00) Mountain Time (US & Canada)</tt> even on September
  # 1st, when the GMT offset is actually -06:00.
  #
  # We don't simply try to adjust the offset ourselves, because a time zone
  # is divorced from a particular time, so if a given time zone observes
  # Daylight Saving Time, then there is no single offset that is correct.
  #
  # Most likely we could figure out whether the time zone is believed
  # to currently observe Daylight Saving Time (with something like
  # <i>zone</i><tt>.tzinfo.current_period.offset.dst?</tt>), but that
  # may be a fairly expensive operation, since the tzinfo is normally
  # lazily loaded for the few time zones that are used in a request, but
  # +to_s+ is sent to each of the time zones any time a menu of time zones
  # is created.
  #
  # So, the hack here is definitely sub-optimal, especially for non-US
  # users who will need to know which city has the right offset for
  # them.

  def to_s
    return name
  end
end
