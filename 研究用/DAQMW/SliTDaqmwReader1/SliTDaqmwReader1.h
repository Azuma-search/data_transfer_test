// -*- C++ -*-
/*!
 * @file 
 * @brief
 * @date
 * @author
 *
 */

#ifndef SLITDAQMWREADER1_H
#define SLITDAQMWREADER1_H

#include "DaqComponentBase.h"

#include <daqmw/Sock.h>

#include "SliTSetup.h"
#include "SliTController.h"
#include "SliTReader.h"
#include "SliTBinaryDataFormat.h"
#include "SliTCoordinate.h"
#include "SliTTree.h"
#include "SliTUtil.h"
#include "objects.h"


using namespace RTC;

class SliTDaqmwReader1
  : public DAQMW::DaqComponentBase
{
public:
  SliTDaqmwReader1(RTC::Manager* manager);
  ~SliTDaqmwReader1();
  
  // The initialize action (on CREATED->ALIVE transition)
  // former rtc_init_entry()
  virtual RTC::ReturnCode_t onInitialize();
  
  // The execution action that is invoked periodically
  // former rtc_active_do()
  virtual RTC::ReturnCode_t onExecute(RTC::UniqueId ec_id);

  //+++++++++++++++++++++++++++++++++++++++++++++++++  
  // Input/Output
private:
  DAQMW::Sock*   m_sock; /// socket for data server
  unsigned char* m_data = 0;
  int            m_maxBuf;

  BufferStatus           m_out_status;
  TimedOctetSeq          m_out_data;
  OutPort<TimedOctetSeq> m_OutPort;
  
  //+++++++++++++++++++++++++++++++++++++++++++++++++  
private:
  int daq_dummy      ();
  int daq_configure  ();
  int daq_unconfigure();
  int daq_start      ();
  int daq_run        ();
  int daq_stop       ();
  int daq_pause      ();
  int daq_resume     ();
  
  int  parse_params            (::NVList* list);
  void read_data_from_detectors();
  int  create_buffer_ipaddress ();
  int  set_data                (unsigned int data_byte_size);
  int  write_OutPort           ();

  //+++++++++++++++++++++++++++++++++++++++++++++++++
private:
  // Class for SliT
  SliTReader*           m_slitReader     = 0;
  SliTController*       m_slitController = 0;
  SliTBinaryDataFormat* m_slitBDF        = 0;
  
  //+++++++++++++++++++++++++++++++++++++++++++++++++
private:
  // External Parameters
  bool         m_debug = false;
  int          m_firmwareVersion;
  int          m_srcPort;  // Port No. of data server
  unsigned int m_qvId;    // quarter-vane id
  unsigned int m_boardId; // board_id
  std::string  m_srcAddr;  // IP addr. of data server
  bool         m_isTimeOutFatal; // timeout error is fatal or not
  float        m_timeOut_sec;
  bool         m_isStoreOneEventData = false; // after all data in one event is in place, the output begins
  //+++++++++++++++++++++++++++++++++++++++++++++++++
  const static unsigned int m_nFooterPerEvent = 1; // expected number of footer in one event

  //+++++++++++++++++++++++++++++++++++++++++++++++++
private:
  unsigned int   m_recvByteSize;
  int            m_prevEventNumber = -1;
  int            m_cntIsLastData   =  0;

  bool           m_flReadHeader         = true;
  bool           m_flIsTimeOut          = false;
  bool           m_flIsDetectFooter     = false;
  bool           m_flIsDetectEndOfEvent = false;
  unsigned int   m_nData           = 0;
  unsigned int   m_dataByte        = 0;
  unsigned int   m_eventNumber     = 0;
  bool           m_isLastData      = false;
  int            m_eventDataLength = 0;
};

//+++++++++++++++++++++++++++++++++++++++++++++++++
extern "C"
{
  void SliTDaqmwReader1Init(RTC::Manager* manager);
};

#endif // SLITDAQMWREADER1_H
