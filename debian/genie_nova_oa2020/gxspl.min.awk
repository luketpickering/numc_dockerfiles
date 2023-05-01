#! /usr/bin/gawk -f
# Reduce the combinations of neutrino flavors and target isotopes in a
# GENIE gxspl XML spline file.
#    gawk -f reduce_gxspl.awk gxspl-big.xml > gxspl-small.xml
#
# This only limits what is allowed; if a combination isn't in the
# input file it won't magically appear in the output
#
BEGIN {
  doout=1; keep=1;
  nlines=0; maxlines=0; # set non-zero maxlines only for testing puroses
  # whether to keep each species of neutrino
    nukeep[12] = 1;
    nukeep[-12] = 1;
    nukeep[14] = 1;
    nukeep[-14] = 1;
  # whether to keep particular isotopes
  # Common
    tgtkeep[1000010010] = 1;   # H1
    tgtkeep[1000060120] = 1;   # C12
    tgtkeep[1000080160] = 1;   # O16
    tgtkeep[1000180400] = 1;   # Ar40
}
# decide whether to keep or reject a sub-process x-section based on the
# name string.  Note picking out "nu:XY" and "tgt:XYZ" is dependent on
# the exact naming formulation ... hopefully this won't change.
# example string:
#    <spline name="genie::AhrensNCELPXSec/Default/nu:-14;tgt:1000020040;N:2212;proc:Weak[NC],QES;" nknots="500">
#
/<spline/ {
  keep=0; doout=0;
  # check if we want this set, if yes set both keep & doout = 1
  split($0,array,";");
  split(array[2],tgtarray,":");
  tgtval=tgtarray[2];
  split(array[1],nuarray,"/");
  nuvaltmp=nuarray[3];
  split(nuvaltmp,nuarray,":");
  nuval=nuarray[2];
  #print "tgtarray[2] = ",tgtval," nuarray[2] = ",nuval;
  if ( tgtval in tgtkeep ) {
    #print "keep this tgt ",tgtval;
    if ( nuval in nukeep ) {
      keep=1; doout=1;
    } else {
      # print "reject this nu",nuval;
      keep=0; doout=0;
    }
  } else {
    #print "reject this tgt",tgtval;
    keep=0; doout=0;
  }
}
# close out a particular spline
/<\/spline/ {
  if ( doout == 1 ) { keep = 1 } else { keep = 0 }
  doout=1;
}
# regular lines depend on the current state
// {
  if ( keep  == 1 ) print $0;
  if ( doout == 1 ) keep = 1;
  nlines++;
  if ( maxlines > 0 && nlines > maxlines ) exit
}
# end-of-script reduce_gxspl.awk
