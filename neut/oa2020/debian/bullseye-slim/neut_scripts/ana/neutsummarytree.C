#include "/opt/neut/__NEUT_VERSION__/include/neutvect.h"
#include "/opt/neut/__NEUT_VERSION__/include/neutvtx.h"

#pragma cling load("/opt/neut/__NEUT_VERSION__/lib/libNEUTClass.so")

#include "TTree.h"
#include "TFile.h"
#include "TH1.h"

#include <iostream>

int neutsummarytree(char const *fname = "neutvect.root",
                    char const *oname = "neutflat.root") {

  Int_t i, j;
  Int_t nevents;

  TTree *tn = nullptr;
  NeutVect *nvect = nullptr;

  TFile f(fname);
  if (!f.IsOpen()) {
    std::cout << "[ERROR]: Failed to read file: " << fname << std::endl;
    return 1;
  }

  f.GetObject("neuttree", tn);
  if (!tn) {
    std::cout << "[ERROR]: Failed to read neuttree from: " << fname
              << std::endl;
    return 1;
  }

  tn->SetBranchAddress("vectorbranch", &nvect);

  nevents = tn->GetEntries();

  TFile o(oname, "RECREATE");
  TTree *sumt = new TTree("neutsum", "");

  double Enu, Q2, hmfslep_p, hmfslep_costheta, xsec_weight;
  int Mode, IsBound, PDGnu, PDGlep, NNucLeavingParts, Nprot, Npip, Npim, Npi0,
      Nother;

  sumt->Branch("Enu", &Enu);
  sumt->Branch("Q2", &Q2);
  sumt->Branch("hmfslep_p", &hmfslep_p);
  sumt->Branch("hmfslep_costheta", &hmfslep_costheta);
  sumt->Branch("xsec_weight", &xsec_weight);

  sumt->Branch("Mode", &Mode);
  sumt->Branch("IsBound", &IsBound);
  sumt->Branch("PDGnu", &PDGnu);
  sumt->Branch("PDGlep", &PDGlep);
  sumt->Branch("NNucLeavingParts", &NNucLeavingParts);
  sumt->Branch("Nprot", &Nprot);
  sumt->Branch("Npip", &Npip);
  sumt->Branch("Npim", &Npim);
  sumt->Branch("Npi0", &Npi0);
  sumt->Branch("Nother", &Nother);

  // Try and get the flux/evtrt histograms
  TH1 *flux_numu = nullptr, *evtrt_numu = nullptr;
  f.GetObject("flux_numu", flux_numu);
  f.GetObject("evtrt_numu", evtrt_numu);
  if (flux_numu) {
    xsec_weight = (evtrt_numu->Integral() * 1E-38) /
                  (evtrt_numu->Integral() * double(nevents));
  }

  double prevEnu = 0;

  for (j = 0; j < nevents; j++) {

    tn->GetEntry(j);

    Enu = Q2 = hmfslep_p = hmfslep_costheta = 0;

    Mode = PDGnu = PDGlep = NNucLeavingParts = Nprot = Npip = Npim = Npi0 =
        Nother = 0;

    Mode = nvect->Mode;

    TLorentzVector ISlepp4, FSlepp4;

    for (i = 0; i < nvect->Npart(); i++) {

      if (nvect->PartInfo(i)->fStatus == -1) {

        switch (abs(nvect->PartInfo(i)->fPID)) {
        case 12:
        case 14: {
          PDGnu = nvect->PartInfo(i)->fPID;
          ISlepp4 = nvect->PartInfo(i)->fP;
        }
        default: {
          continue;
        }
        }

      } else if ((nvect->PartInfo(i)->fStatus == 0) &&
                 nvect->PartInfo(i)->fIsAlive) {

        NNucLeavingParts++;
        switch (abs(nvect->PartInfo(i)->fPID)) {
        case 11:
        case 13:
        case 12:
        case 14: {
          if (FSlepp4.Mag2() == 0) {
            PDGlep = nvect->PartInfo(i)->fPID;
            FSlepp4 = nvect->PartInfo(i)->fP;
          }
          continue;
        }
        case 2212: {
          Nprot++;
          continue;
        }
        case 211: {
          Npip++;
          continue;
        }
        case -211: {
          Npim++;
          continue;
        }
        case 111: {
          Npi0++;
          continue;
        }
        default: {
          Nother++;
          continue;
        }
        }
      }
    }

    Enu = ISlepp4.E();
    Q2 = -(ISlepp4 - FSlepp4).Mag2();
    hmfslep_p = FSlepp4.Vect().Mag();
    hmfslep_costheta = FSlepp4.Vect().CosTheta();

    if (!flux_numu) {
      if (!j) {
        prevEnu = Enu;
        xsec_weight = nvect->Totcrs * 1E-38 / double(nevents);
      } else {
        if (Enu != prevEnu) {
          std::cout << "[ERROR]: Failed to find flux_numu, but input file also "
                       "appears to not be mono energetic."
                    << std::endl;
          return 2;
        }
      }
    }

    sumt->Fill();
  }

  o.Write();
  o.Close();

  return 0;
}
