
#include "TFile.h"
#include "TH1D.h"

void makeflatflux(char const * file, double low, double up) {
  TFile *ff = new TFile(file,"RECREATE");

  TH1D *f = new TH1D("flux", "flux", 100, low, up);

  for (int i = 0; i < f->GetXaxis()->GetNbins(); ++i) {
    double e = exp(-0.2*f->GetXaxis()->GetBinCenter(i + 1));
    e = std::min(e, 0.5);
    e = std::max(e, 0.05);
    f->SetBinContent(i + 1, e);
  }

  ff->WriteObject(f, "flux");
  ff->Close();
}
